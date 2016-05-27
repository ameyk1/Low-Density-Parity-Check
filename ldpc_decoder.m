 %Engineer: Amey Kulkarni
 %Module Name:  ldpc_decoder
 %Project Name: Low Density Parity Check

clear all;
clc;

%%%%%%%%%%%%%%%
% Initialize. %
%%%%%%%%%%%%%%%

% Define the constants.
NROWS = 6;
NCOLS = 12;
H = [3 4 8 10; 1 5 9 11; 2 6 7 11; 3 5 7 12; 1 6 8 12; 2 4 9 10];

fprintf('---------------------------------------------------------\n');
fprintf('-- Given Values\n');
fprintf('---------------------------------------------------------\n');

% Define the received codeword.
%lamda = [-9.1 4.9 -3.2 3.6 -1.4 3.1 0.3 1.6 -6.1 -2.5 -7.8 -6.8]
lamda = [-0.5564 2.5132 -2.8639 1.7114 -0.7370 -0.0790 -1.3578 1.2827 ...
    1.9527 1.2852 -2.1138 1.5042]
iterations = 5
fractional_bits = 3
sfactor = 1

[rows_in_H, cols_in_H] = size(H);
z = zeros(1, NCOLS);
v_hat = zeros(1, NCOLS);
hard_decision = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Variable Node Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('---------------------------------------------------------\n');
fprintf('-- Pre-Processing\n');
fprintf('---------------------------------------------------------\n');

for i = 1:NCOLS
    lamda(i) = round(lamda(i) * (2^fractional_bits))/(2^fractional_bits);
end

lamda

% Initialize the alpha matrix to all zeroes.
alpha = zeros(NROWS, NCOLS)
%alpha_x8 = zeros(NROWS, NCOLS)

% Initialize the values of beta using lamda.
beta = zeros(NROWS, NCOLS);
beta_x8 = zeros(NROWS, NCOLS);

for i = 1:rows_in_H
    for j = 1:cols_in_H
        beta(i, H(i, j)) = lamda(H(i,j));
        beta_x8(i, H(i, j)) = beta(i, H(i, j)) * 8;
    end
end

beta
%beta_x8

% Perform an initial code estimation.
for j = 1:NCOLS
    if lamda(1,j) > 0
        v_hat(1,j) = 0;
    else
        v_hat(1,j) = 1;
    end
end

v_hat

% Perform an initial syndrome check.
syndrome = zeros(1, NROWS);
for i = 1:rows_in_H
    for j = 1:cols_in_H
        syndrome(1,i) = mod(syndrome(1,i) + v_hat(1, H(i,j)), 2);
    end
end

syndrome

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Intialize the iteration counter.
iteration = 1;

while iteration <= iterations

    fprintf('\n');
    fprintf('---------------------------------------------------------\n');
    fprintf('-- Iteration #%0d\n', iteration);
    fprintf('---------------------------------------------------------\n');
    iteration = iteration + 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check Node Processing
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:rows_in_H
        for j = 1:cols_in_H

            % Calculate the sign and magnitude of the new value of 
            % alpha(i,j).
            sign = 1;
            magnitude = 1000;
            
            for k = 1:cols_in_H    
                if k ~= j

                    if beta(i, H(i,k)) < 0
                        sign = sign * -1;
                    end

                    if abs(beta(i, H(i,k))) < magnitude
                        magnitude = abs(beta(i, H(i,k)));
                    end

                end
            end
            
            % Update the alpha matrix.
            alpha(i, H(i,j)) = sign * magnitude * sfactor;
            %alpha_x8(i, H(i,j)) = alpha(i, H(i,j)) * 8;

        end
    end

    alpha
    %alpha_x8

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variable Node Processing
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:rows_in_H
        for j = 1:cols_in_H

            % Sum the elements of the column of alpha indicated by the H
            % matrix.
            sum_alpha = sum(alpha(:,H(i,j)), 1);

            % Calculate the value of z for this column by adding in the 
            % lamda value.
            z(1, H(i,j)) = sum_alpha + lamda(H(i,j));

            % Calculate the value of beta by subtracting out the value of 
            % alpha corresponding to the current row.
            beta(i, H(i, j)) = z(1, H(i,j)) - alpha(i, H(i, j));
            
            % Saturate the value of beta.
            if (beta(i, H(i, j)) > (2^(3-1)-2^(-fractional_bits)))
                beta(i, H(i, j)) = (2^(3-1)-2^(-fractional_bits));
            elseif (beta(i, H(i, j)) < (-2^(3-1)))
                beta(i, H(i, j)) = (-2^(3-1));
            end
            
            beta_x8(i, H(i, j)) = beta(i, H(i, j)) * 8;
            
        end
    end
    
    beta
    %beta_x8
    
    z

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Code Estimation
    % http://www.mathworks.com/help/comm/ref/ldpcdecoder.html
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j = 1:NCOLS
        if z(1,j) >= 0
            v_hat(1,j) = 0;
        else
            v_hat(1,j) = 1;
        end
    end

    v_hat
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Syndrome Check
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    syndrome = zeros(1, NROWS);
    for i = 1:rows_in_H
        for j = 1:cols_in_H
            syndrome(1,i) = mod(syndrome(1,i) + v_hat(1, H(i,j)), 2);
        end
    end
    
    syndrome
    
    if sum(syndrome,2) == 0
        hard_decision = 1;
    end
    
end
