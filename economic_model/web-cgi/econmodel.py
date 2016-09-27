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
    grid_size   = 1     # grid max load [GW_e]
    storage_eff = 0.95  # round-trip thermal storage efficiency
    heat_eff    = 0.45  # efficiency of the power conversion W_th -> W_e
    solar_fract = 0.15  # solar fraction of peak grid load
else :
    grid_size   = float(cgi_fields.getvalue('grid_size'))
    storage_eff = float(cgi_fields.getvalue('storage_eff'))
    heat_eff    = float(cgi_fields.getvalue('heat_eff'))
    solar_fract = float(cgi_fields.getvalue('solar_fract'))
dir_figs='/var/www/html/images/econmodel'  # where to write plot
do_plot = 1             # make the plot

# HTML header
html_header='''Content-Type: text/html;charset=utf-8

<html><head><title>MSiBR ecomonic model</title></head>
<h1>MSiBR ecomonic model</h1>
<p>Simple web app to demonstrate our tool</p>'''

# HTML input form
html_form='''<form action="/cgi-bin/econmodel.py" method="post">
<fieldset><legend>Enter imput parametrs:</legend>
Size of the electric grid [GWe]: <br>
<input type="text" name="grid_size" value="{0:}" size=5><br>
Solar fraction of the grid size: <br>
<input type="text" name="solar_fract" value="{3:}" size=5><br>
Round trip efficiency of thermal storage: <br>
<input type="text" name="storage_eff" value="{1:}" size=5><br>
Power conversion efficiency:<br>
<input type="text" name="heat_eff" value="{2:}" size=5><br>
<input type="submit" value="Submit">
</form></fieldset>''' . format(grid_size, storage_eff, heat_eff, solar_fract)

# HTML footer
html_footer='''</body></html>'''

# Main code starts here
print(html_header)
print(html_form)

if len(cgi_fields.keys()) == 4:
    grid_size_We = 1e9*grid_size    # GWe -> We
    size_data = plant_size(grid_size_We, storage_eff, heat_eff, solar_fract, do_plot, dir_figs)
    print('<p><pre>' + size_data + '</p></pre>')
    print('<p><img src="/images/econmodel/mygrid.png" alt="Grid load figure"/></p>')

print(html_footer)

