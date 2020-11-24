%% This function is the Newkirk electron-density model 
% Reference: Newkirk, G. Jr.: The solar corona in active regions and the
% thermal origin of the slowly varying component of solar radio radiation.
% Astrophys. J. 133, 983 (1961) 

% Written by: Mohamed Nedal 
function [n_e, r_nk] = newkirk(hr, f, a) 
    % hr: [1] for fundamental backbone, [2] for Harmonic backbone. 
    % f: frequency (MHz). 
    % a: fold (1 - 4, [1] for quiet Sun, [4] for active regions). 
    n_e = ((f*1e6)/(hr*9000)).^2; 
    r_nk = (4.32./log10(n_e/(a*4.2e4))); 
end 
