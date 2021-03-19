% 运行这个脚本前，先运行test(或main)程序
% YX 降雨量
XX = ppt;
% Z:    Shepard 
% YX：   Kriging
% vql :     线性插值
% vql_natural :自然邻点插值
EAtype = '3';   % 1:Shepard ;  2:Kriging  3:线性插值;  4:自然邻点插值
YX_index = sort( [1 round(rand(1,9)*length(XX)) length(XX)] );

YX_10 = zeros(1,length(XX));
for i = 1:10
    
%     需要插值的点
%     YX_x = lon_plane(YX_index(i):YX_index(i+1));
%     YX_y = lat_plane(YX_index(i):YX_index(i+1));
    YX_x = lon(YX_index(i):YX_index(i+1));
    YX_y = lat(YX_index(i):YX_index(i+1));
    
    % 用于插值的基准数据
    yx_x = lon_plane;
    yx_x(YX_index(i):YX_index(i+1)) = [];
    yx_y = lat_plane;
    yx_y(YX_index(i):YX_index(i+1)) = [];
    yx = YX;
    yx(YX_index(i):YX_index(i+1)) = [];
    
    % 插值
    switch EAtype
    case '1' 
        [IDW_]=IDW(yx_x,yx_y,yx,YX_x,YX_y);
        XX_10(YX_index(i):YX_index(i+1)) = IDW_;
        
    case '2' 
        [Kriging_,~] = predictor([YX_x YX_y], dmodel);
        XX_10(YX_index(i):YX_index(i+1)) = Kriging_;
    case '3'
        F.Method = 'linear';       % 'linear':线性插值;'nearest':最近邻点插值;
        vql_ = F(YX_x,YX_y);
        XX_10(YX_index(i):YX_index(i+1)) = vql_;
    case '4' 
        F.Method = 'natural';
        [vql_natural,~] = predictor([YX_x YX_y], dmodel); % 'natural':自然邻点插值
        XX_10(YX_index(i):YX_index(i+1)) = vql_natural;
    otherwise
        warning('没有这个选项.')
    end
end

% 误差分析
if sum(size(XX)==size(XX_10)) == 0
    XX_10 = XX_10';
end
RMSE = sqrt( 1/length(XX) * sum( (XX - XX_10).^2 ) );   %均方根误差
MAE =  1/length(XX) * sum( abs(XX - XX_10));    %平均绝对误差
S = sqrt( 1/(length(XX)-1) * sum( (Z-mean(XX)).^2 ) );  %样本标准差
XX_pearson = corr(XX,XX_10);    %相关系数
XX_pearson 
MAE
RMSE
S