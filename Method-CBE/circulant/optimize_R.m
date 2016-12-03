function [fft_r, obj] = optimize_R(B, fft_X, fft_r, m, para)

    verbose = para.verbose;
    lambda = para.lambda;

    % fft_r is the fft of initial r
    fft_B = fft(B,[],2);
    d = size(B,2);
    
    % compute h1
    h = -2* sum(   real(fft_X).*real(fft_B) + imag(fft_X).*imag(fft_B)  , 1);
    h = h'/d;
    % compute h2
    g = 2*  sum(   imag(fft_X).*real(fft_B) - real(fft_X).*imag(fft_B)  , 1);
    g = g'/d;
    
    if (verbose)
       fprintf('optimize R obj (IN): %f \n', compute_obj(fft_B, m, h, g, fft_r, lambda)); 
    end
    
    % optimize fft_r
    options.GradObj = 'on';
    options.Display = 'off';
    options.LargeScale = 'off';
    options.HessUpdate = 'bfgs';
    options.Diagnostics = 'off';

    fft_r(1) = fminunc(@(r0)fun_r0(r0, m(1), h(1), lambda), real(fft_r(1)), options);
    
    parfor i = 2:ceil((d+1)/2)
       x(1) = real(fft_r(i));
       x(2) = imag(fft_r(i));
       x = fminunc(@(x)fun_r(x, m(i), h(i), g(i), m(d-i+2), h(d-i+2), g(d-i+2), lambda), x, options);
       fft_r(i) = x(1) + 1i*x(2);
       %fft_r(d-i+2)= x(1) - 1i*x(2);
    end
    
    % this is necessary for parfor look
    for i = 2:ceil((d+1)/2)
       fft_r(d-i+2)= fft_r(i)';
    end
    
    obj = compute_obj(fft_B, m, h, g, fft_r, lambda);
    if (verbose)
       fprintf('optimize R obj (OUT): %f \n', obj);
    end
end    


function [f, df] = fun_r0(r0, m0, h0, lambda)

f = m0*r0^2 + h0*r0 + lambda * (r0^2 -1)^2;
df = 2*m0*r0 + h0 + 4*lambda*(r0^2 - 1)* r0;

end


function [f, df] = fun_r(x, mi, hi, gi, md, hd, gd, lambda)
r_ri = x(1);
i_ri = x(2);

%f = mi*(r_ri^2 + i_ri^2) + hi*r_ri + gi*i_ri + lambda * (r_ri^2 + i_ri^2 -1)^2 + ...
%            md*(r_ri^2 + i_ri^2) + hd*r_ri - gd*i_ri + lambda * (r_ri^2 + i_ri^2 -1)^2;

f = (mi+md)*(r_ri^2 + i_ri^2) + (hi + hd)*r_ri + (gi - gd)*i_ri + 2*lambda * (r_ri^2 + i_ri^2 -1)^2;
df = zeros(2,1);
%df(1) = 2*mi*r_ri + hi + 2*lambda*(r_ri^2 + i_ri^2 -1)*2*r_ri + ...
%        2*md*r_ri + hd + 2*lambda*(r_ri^2 + i_ri^2 -1)*2*r_ri;
    
df(1) = 2*(mi+md)*r_ri + hi + hd + 8*lambda*(r_ri^2 + i_ri^2 -1)*r_ri;

%df(2) = 2*mi*i_ri + gi + 2*lambda*(r_ri^2 + i_ri^2 -1)*2*i_ri + ...
%        2*md*i_ri - gd + 2*lambda*(r_ri^2 + i_ri^2 -1)*2*i_ri;
df(2) = 2*(mi+md)*i_ri + gi - gd + 8*lambda*(r_ri^2 + i_ri^2 -1)*i_ri;
end

function obj = compute_obj(fft_B, m, h, g, fft_r, lambda)
    d = size(m,1);
    obj = sum(real(fft_r).*real(fft_r).*m) + ...
          sum(imag(fft_r).*imag(fft_r).*m) + ...
          real(fft_r)'*h + ...
          imag(fft_r)'*g;
    obj = obj + sum(sum(real(fft_B).^2 + imag(fft_B).^2))/d;
    %obj = obj/d;
    obj = obj + lambda*sum((real(fft_r).^2 + imag(fft_r).^2 - 1).^2);
end