function MathLab
% MathLab - Scientific and Matrix Calculator
clc;
fprintf('====================================\n');
fprintf('      Welcome to MathLab\n');
fprintf('   Advanced Scientific Calculator\n');
fprintf('====================================\n');

while true
    fprintf('\n1.  Addition\n2.  Subtraction\n3.  Multiplication\n');
    fprintf('4.  Division\n5.  Power\n6.  Square Root\n');
    fprintf('7.  Sine (degrees)\n8.  Cosine (degrees)\n9.  Tangent (degrees)\n');
    fprintf('10. Natural Logarithm\n11. Common Logarithm\n12. Exponential\n');
    fprintf('13. Factorial\n14. Absolute Value\n15. Matrix Calculator\n0.  Exit\n');

    choice = str2double(input('Select operation: ', 's'));
    if choice == 0
        disp('Thank you for using MathLab!');
        break;
    elseif choice == 15
        matrixCalculator();
        continue;
    elseif ~ismember(choice, 1:14)
        disp('Invalid choice! Try again.');
        continue;
    end

    try
        a = readNumber('Enter first number: ');
        if choice <= 5
            b = readNumber('Enter second number: ');
        end

        switch choice
            case 1
                result = a + b;
            case 2
                result = a - b;
            case 3
                result = a * b;
            case 4
                if b == 0, error('Division by zero.'); end
                result = a / b;
            case 5
                result = a ^ b;
            case 6
                if a < 0, error('Enter a non-negative number.'); end
                result = sqrt(a);
            case 7
                result = sind(a);
            case 8
                result = cosd(a);
            case 9
                if abs(cosd(a)) < 1e-12, error('Tangent is undefined at this angle.'); end
                result = tand(a);
            case 10
                if a <= 0, error('Enter a positive number.'); end
                result = log(a);
            case 11
                if a <= 0, error('Enter a positive number.'); end
                result = log10(a);
            case 12
                result = exp(a);
            case 13
                if a < 0 || a ~= floor(a) || a > 170
                    error('Enter an integer from 0 to 170.');
                end
                result = factorial(a);
            case 14
                result = abs(a);
        end
        if ~isreal(result) || isnan(result) || isinf(result)
            error('Result is outside the supported real range.');
        end
        fprintf('Result = %.10g\n', result);
    catch ME
        fprintf('Error: %s\n', ME.message);
    end
end
end

function matrixCalculator()
while true
    fprintf('\n====================================\n');
    fprintf('      MathLab Matrix Calculator\n');
    fprintf('====================================\n');
    fprintf('1. Matrix Addition\n2. Matrix Subtraction\n3. Matrix Multiplication\n');
    fprintf('4. Transpose\n5. Determinant\n6. Inverse\n7. Rank\n');
    fprintf('8. Eigenvalues\n9. Reduced Row Echelon Form\n10. Trace\n');
    fprintf('0. Return to main calculator\n');

    choice = str2double(input('Select matrix operation: ', 's'));
    if choice == 0
        return;
    elseif ~ismember(choice, 1:10)
        disp('Invalid choice! Try again.');
        continue;
    end

    try
        A = readMatrix('Enter matrix A (e.g. [1 2; 3 4]): ');
        if choice <= 3
            B = readMatrix('Enter matrix B: ');
        end
        if ismember(choice,[5 6 8 10]) && size(A,1) ~= size(A,2)
            error('Matrix must be square.');
        end

        switch choice
            case 1
                if ~isequal(size(A),size(B)), error('Matrix sizes must match.'); end
                result = A + B;
            case 2
                if ~isequal(size(A),size(B)), error('Matrix sizes must match.'); end
                result = A - B;
            case 3
                if size(A,2) ~= size(B,1), error('Matrix dimensions are incompatible.'); end
                result = A * B;
            case 4
                result = A.';
            case 5
                result = det(A);
            case 6
                if rcond(A) < 1e-12, error('Matrix is singular or nearly singular.'); end
                result = inv(A);
            case 7
                result = rank(A);
            case 8
                result = eig(A);
            case 9
                result = rref(A);
            case 10
                result = trace(A);
        end
        disp('Result:');
        disp(result);
    catch ME
        fprintf('Error: %s\n', ME.message);
    end
end
end

function n = readNumber(prompt)
n = str2double(input(prompt,'s'));
if ~isreal(n) || isnan(n) || isinf(n)
    error('Enter a valid real number.');
end
end

function A = readMatrix(prompt)
% Accept numbers separated by spaces/commas and rows by semicolons.
s = strtrim(input(prompt,'s'));
if numel(s) >= 2 && s(1) == '[' && s(end) == ']'
    s = strtrim(s(2:end-1));
end
rows = strsplit(s,';','CollapseDelimiters',false);
A = [];
for k = 1:numel(rows)
    row = strtrim(rows{k});
    if isempty(row), error('Matrix rows cannot be empty.'); end
    parts = regexp(row,'[\s,]+','split');
    values = str2double(parts);
    if ~isreal(values) || any(isnan(values)) || any(isinf(values))
        error('Enter a matrix containing real numbers only.');
    end
    if k > 1 && numel(values) ~= size(A,2)
        error('All rows must have the same number of columns.');
    end
    A = [A; values]; %#ok<AGROW>
end
end
