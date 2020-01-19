function [n_e, r_nk] = newkirk(hr, f, a) 
    % hr: [1] for fundamental backbone, [2] for Harmonic Backbone. 
    % f: frequency (MHz). 
    % a: fold (1 - 4, [1] for quiet Sun, [4] for active regions). 
    n_e = ((f*1e6)/(hr*9000)).^2; 
    r_nk = (4.32./log10(n_e/(a*4.2e4))); 
end 
