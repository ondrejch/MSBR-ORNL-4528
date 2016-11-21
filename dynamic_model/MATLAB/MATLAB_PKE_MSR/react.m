% Get reactivity value from input file for some t. 
function rho=react(t)
global nrows;
global input_data;
  if (t>input_data(nrows,1))
    rho=input_data(nrows,2);
  else
    for i = 1:nrows-1
      if (t>=input_data(i,1) & t<=input_data(i+1,1))
        rho=input_data(i,2);
        break
        else
          continue
      end
    end
  end  
end