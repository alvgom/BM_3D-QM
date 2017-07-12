function y = jitter(x,varargin)

amount = [];
factor = 1;
if size(x,1)==1
    x = x';
end
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'amount'
            amount = varargin{i+1};
        case 'factor'
            factor = varargin{i+1};
        case 'DTcorrection'
            if varargin{i+1}
                amount = 0.4;
                x(x==0) = amount;
            end
    end
end

z = max(x)-min(x);
if z == 0
    z = min(x);
end
if z == 0
    z = 1;
end
if isempty(amount)
    d_aux = diff(unique(x));
    d = min(d_aux);
    amount = factor*abs(d)/5;
elseif amount == 0
    amount = factor*z/50;
end
rnoise = -amount+amount*2*rand(length(x),1);
y = x+rnoise;