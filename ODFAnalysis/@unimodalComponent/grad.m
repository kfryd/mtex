function g = grad(component,ori,varargin)
% gradient at orientation g
%
% Syntax
%   g = grad(component,ori)
%
% Input
%  component - @unimodalComponent
%  ori - @orientation
%
% Options
%  exact -
%  epsilon -
%
% Description
% general formula:
%
% $$s(g1_i) = sum_j c_j DK(g1_i,g2_j) $$


% we need to consider all symmetrically equivalent centers
q2 = quaternion(ori);
center = component.center;
qSS = unique(quaternion(component.SS));
psi = component.psi;
epsilon = min(pi,get_option(varargin,'epsilon',psi.halfwidth*3.5));

% initialize output
g = vector3d.zeros(size(ori));

% comute the distance matrix and evaluate the kernel
for issq = 1:length(qSS)
  d = abs(dot_outer(center,qSS(issq) * q2,'epsilon',epsilon,...
    'nospecimensymmetry'));
  
  d(d<=cos(epsilon/2)) = 0;
  
  [i,j] = find(d>cos(epsilon/2));
  
  % the normalized logarithm
  v = log(center(i),reshape(qSS(issq) * ori(j),[],1));
  nv = norm(v);
  v(nv>0) = v(nv>0)./nv(nv>0);
  
  v = sparse(i,j,v,length(center),length(ori)) .* spfun(@psi.DK,d);
  
  g = g - v.' * component.weights;
  
end

% TODO: consider antipodal
if component.antipodal
  
end

