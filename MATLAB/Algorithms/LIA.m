%% Right Inverse Model Algorithm
%K0 = G_L, where G_L is the left inverse of the matrix G, if G_L exists, 
%Here: use Moore-Penrose pseudoinverse
%beta=const
%Input: G: Plant Model in supervector form
%       d: additional term in Plant Model: y = Gu + d
%       K0: Learning Matrix
%       beta: design parameter, 0<beta<1; Here: beta is the quota of max.
%       possible beta to be chosen. For beta = 1/2 get solution in one
%       iteration, but bad robustness properties. 
%       u0: initial input signal
%Output: u_inf: cell array, input signal sequence over each 5 iterations
%        e_inf: cell array, includes the error norm over each 5 iterations
%        y_inf: cell array, output signal sequence over each 5 iterations
%        impr: improvement: ||e0||/e_inf{end}, wehere e0 is the initial error
%        iteration_number: number of iterations needed
%        error_history: vector, error norm for each iteration (e_inf is a
%        subset of error_history)
function [u_inf, e_inf, y_inf, impr,iteration_number, error_history] = LIA(G,d, beta,r, u0,  do_plot)

if rank(full(G))~=length(G(1,:))
    disp('Error: G has not full column rank. Can not compute left inverse')
    u_inf = -1;
    e_inf = -1;
    y_inf = -1;
    impr = -1;
    iteration_number = -1;
    error_history = -1;
else
    K0 = pinv(full(G)')';
    K0 = sparse(K0);
    beta_max = 2;
    beta = beta*beta_max;
    [u_inf, e_inf, y_inf, impr,iteration_number, error_history] = CGA(G,d, K0,beta,r, u0, do_plot);
end

end

