%%
%Conceptual Gradient Algorithm for non-constant beta
%Input: G: Plant Model in supervector form
%       d: additional term in Plant Model: y = Gu + d
%       K0: Iterative Matrix
%       beta_vec: design parameter for first iterations, vectors are
%       allowed
%       beta_const: design parameter for the next iterations, constant
%       
%        u0: start input signal
%Output: u_inf: cell array, input signal sequence over each 5 iterations
%        e_inf: cell array, includes the error norm over each 5 iterations
%        y_inf: cell array, output signal sequence over each 5 iterations
%        impr: improvement: ||e0||/e_inf{end}, wehere e0 is the initial error
%        iteration_number: number of iterations needed
%        error_history: vector, error norm for each iteration (e_inf is a
%        subset of error_history)
function [u_inf, e_inf, y_inf, impr, iteration_number,error_history] = CGA_beta(G,d, K0,r,beta_vec, beta_const, u0,do_plot)

%define initial parameter
u = u0;
e0 = r - G*u - d; 
e = e0;
iteration_number = 0;
error_history = [norm(e0)];
cont = 1;
GK0 = G*K0;%conculate once

% sequencies setup
u_inf = {};
e_inf = {};
y_inf = {};
cell_nb = 0;
while cont
    iteration_number = iteration_number + 1;
    %calculate u_new and e_new with update rules
    %choose beta
    b = beta_const;
    if iteration_number<=length(beta_vec)
        b = beta_vec(iteration_number);
    end
    
    u_new = u + b*K0*e;
    e_new = (eye(length(e0)) - b*GK0)*e;
    
    %Termination criterion
    if norm(e - e_new)<10^-6
        cont = 0;
    end
    error_history = [error_history, norm(e_new)];
   
    %print current imprivement
    if(mod(iteration_number, 10000) == 0)
        disp("currErrordiff:")
        norm(e_new - e)
    end
    u = u_new;
    e = e_new;
    
    %save data over each 5 iteration for plots
    if mod(iteration_number,5) == 0
        cell_nb = cell_nb + 1;
        u_inf{cell_nb} = u_new;
        e_inf{cell_nb} = norm(e_new);
        y_inf{cell_nb} = G*u_new + d;
    end
    
    
end

if mod(iteration_number,5) ~= 0
        cell_nb = cell_nb + 1;
        u_inf{cell_nb} = u_new;
        e_inf{cell_nb} = norm(e_new);
        y_inf{cell_nb} = G*u_new + d;
end

impr = norm(e0)/e_inf{end};


if do_plot
    plot(0:iteration_number, error_history);
end

end

