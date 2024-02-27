function output = smoothing(input)
input_length = length(input);
output = zeros(input_length, 1);
average_size = 5;

for i=1:input_length
    if i<average_size
        output(i) = input(i);
    else
        output(i) = sum(input(i-(average_size-1):i))/average_size;
    end
end

for i=1:input_length
    if i<average_size || i>length(input) - average_size
        output(i) = input(i);
    else
        output(i) = sum(input(i-(average_size-1):i+average_size))/(average_size*2);
    end
end