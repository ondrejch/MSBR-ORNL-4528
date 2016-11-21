% Get external source value from input file for some t. 
function S=source(t)
global nrows;
global input_data;
  if (t>input_data(nrows,1))
    S=input_data(nrows,3);
  else
    for i = 1:nrows-1
      if (t>=input_data(i,1) & t<=input_data(i+1,1))
        S=input_data(i,3);
        break
        else
          continue
      end
    end
  end
end