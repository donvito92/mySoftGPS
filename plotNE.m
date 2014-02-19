for i = 1 : size(CC, 1)
    for j = 1 : size(CC, 2)
        mat(i,j) = CC(i,j,up,bias);
    end
end

h = bar3(mat);

for k = 1:length(h)
    zdata = get(h(k),'ZData');
    set(h(k),'CData',zdata,...
             'FaceColor','interp')
end
