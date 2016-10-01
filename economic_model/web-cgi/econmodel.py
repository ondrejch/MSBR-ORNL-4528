#!/usr/bin/env python3

# Call subprocess
from subprocess import call

# Import modules for CGI handling 
import cgi, cgitb 

# Import plant sizing module
from plant_sizing import plant_size

# Create instance of FieldStorage 
cgi_fields = cgi.FieldStorage() 

# Assign input values
if len(cgi_fields.keys()) == 0 :  # default inputs
    grid_size_in   =  1.0  # grid max load [GW_e]
    storage_eff_in = 95.0  # round-trip thermal storage efficiency [%]
    heat_eff_in    = 45.0  # efficiency of the power conversion W_th -> W_e [%]
    solar_fract_in = 15.0  # solar fraction of peak grid load [%]
else :
    grid_size_in   = cgi_fields.getvalue('grid_size')
    storage_eff_in = cgi_fields.getvalue('storage_eff')
    heat_eff_in    = cgi_fields.getvalue('heat_eff')
    solar_fract_in = cgi_fields.getvalue('solar_fract')
dir_figs='/var/www/html/images/econmodel'  # where to write plot
do_plot     = 1           # make the plot
text_in_fig = 0           # put text in figure

# First validate input 
validated = True
try :
    grid_size   = float(grid_size_in)
    storage_eff = float(storage_eff_in)
    heat_eff    = float(heat_eff_in)
    solar_fract = float(solar_fract_in)    
except ValueError :
    validated = False
    val_msg   = 'ERROR: All input has to be numeric.'
if validated and not (solar_fract >= 0.0 and  solar_fract < 200.0) :
    validated = False
    val_msg   = 'ERROR: Solar fraction has to be between 0 and 200%.'
if validated and not (heat_eff >= 30.0 and heat_eff <= 90.0) :
    validated = False
    val_msg   = 'ERROR: Heat engine efficiency has to be between 30 and 90%.'
if validated and not (storage_eff >= 50.0 and storage_eff <= 100.0) :
    validated = False
    val_msg   = 'ERROR: Heat strorage effciency has to be between 50 and 100%'
if not validated:          # if validation fails, use defaults
    grid_size_in   =  1.0  # grid max load [GW_e]
    storage_eff_in = 95.0  # round-trip thermal storage efficiency [%]
    heat_eff_in    = 45.0  # efficiency of the power conversion W_th -> W_e [%]
    solar_fract_in = 15.0  # solar fraction of peak grid load [%]

# HTML header
html_header = '''Content-Type: text/html;charset=utf-8

<html><head><title>MSiBR ecomonic model</title>
<h1>MSiBR ecomonic model</h1>
<p>Simple web app to demonstrate our tool - work in progress</p>'''

# HTML input form
html_form = '''
<form action="/cgi-bin/econmodel.py" method="post" id="inputdata">
<fieldset><legend>Enter in-put parametrs:</legend>
Size of the electric grid [GWe]: <br>
<input type="text" name="grid_size" value="{0:}" size=5><br>
Solar fraction of the grid size [%]: <br>
<input type="text" name="solar_fract" value="{3:}" size=5><br>
Round trip efficiency of thermal storage [%]: <br>
<input type="text" name="storage_eff" value="{1:}" size=5><br>
Power conversion efficiency [%]:<br>
<input type="text" name="heat_eff" value="{2:}" size=5><br>
<input type="submit" value="Submit">
</form></fieldset>''' . format(grid_size, storage_eff, heat_eff, solar_fract)

# HTML footer
html_footer = '''</body></html>'''

# Main code starts here
print(html_header)
print(html_form)

if len(cgi_fields.keys()) == 4 and validated:
    grid_size_We = 1e9*grid_size    # GWe -> We
    size_data = plant_size(grid_size_We, storage_eff/100.0, heat_eff/100.0, 
        solar_fract/100.0, do_plot, text_in_fig, dir_figs)
    print('<p><pre>' + size_data + '</p></pre>')
    print('<p><img src="/images/econmodel/mygrid.png" alt="Grid load figure"/></p>')

if not validated :
    print('<p>' + val_msg + '</p>')

print(html_footer)

