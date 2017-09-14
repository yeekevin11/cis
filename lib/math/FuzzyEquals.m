function boolean = FuzzyEquals(a, b, tolerance)
% FUZZYEQUALS Compare all elements within a tolerance.
if nargin < 3
    tolerance = 1e-6;
end
a_vector = reshape(a, 1, numel(a));
b_vector = reshape(b, 1, numel(b));
boolean = all(abs(a_vector - b_vector) < tolerance);
end
