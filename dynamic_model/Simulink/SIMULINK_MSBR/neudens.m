function ndot=neudens(t,y,bet,B,lam,L)
ndot=zeros(7,1);
  ndot(1) = (((-B)/L)*y(1)) + (lam(1)*y(2)) + ...
  (lam(2)*y(3)) + (lam(3)*y(4)) + (lam(4)*y(5)) + (lam(5)*y(6)) + (lam(6)*y(7));
  ndot(2) = ((bet(1)/L)*y(1)) - (lam(1)*y(2));
  ndot(3) = ((bet(2)/L)*y(1)) - (lam(2)*y(3));
  ndot(4) = ((bet(3)/L)*y(1)) - (lam(3)*y(4));
  ndot(5) = ((bet(4)/L)*y(1)) - (lam(4)*y(5));
  ndot(6) = ((bet(5)/L)*y(1)) - (lam(5)*y(6));
  ndot(7) = ((bet(6)/L)*y(1)) - (lam(6)*y(7));
end