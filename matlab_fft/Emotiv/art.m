
figure
hold on;
for i=1:14
    for j=1:20
        for f=1:32
        tempplot(j) = trialPower(f,i,j);
        end
    end
    plot(tempplot);
end

