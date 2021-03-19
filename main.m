clc
clear
close all
load data
data = data;
% num= xlsread('data.xls')
%获取精度纬度
lon= data(:,2);     %经度
lat = data(:,3);    %纬度
ppt = data(:, 4);   %降雨量

% figure(1) 原图
% figure(2) 克里斯金插值法
% figure(3) 反距离加权
% figure(4) 线性插值
% figure(5) 自然邻点插值插值

%%
figure1=figure;
%创建axes句柄
%展示中国边界
gx=shaperead('黔西南.shp','UseGeoCoords',true);
geoshow(gx,'FaceColor',[1,1,1],'EdgeColor','black');
%设置坐标轴
%设置坐标轴标签
xlabel('Longitude(°E)', 'fontsize', 12, 'fontweight', 'b');
ylabel('Latitude(°N)', 'fontsize', 12, 'fontweight', 'b');
%显示四周边框
box on;
hold on;
out = Edge_Judge(lon,lat,[gx.Lon],[gx.Lat]);
lon(out) = [];
lat(out) = [];
ppt(out) = [];
clear out
scatter(lon, lat, 15, ppt, 'filled');
colorbar('location', 'southoutside');
color_data = ppt;
for i=1:length(ppt)
    if color_data(i) <=0
        color_data(i)=0;
    elseif color_data(i)>0 && color_data(i)<=5
        color_data(i)= 5;
    elseif color_data(i)>5 && color_data(i)<=10
        color_data(i)= 10;
    elseif color_data(i)>10 && color_data(i)<=15
        color_data(i)=15;
    elseif color_data(i)>15 && color_data(i)<=20
        color_data(i)=20;
    elseif color_data(i)>20 && color_data(i)<=25
        color_data(i)=25;
    else
        color_data(i)=30;
    end
end
mycolor6 = [
0.4784 0.0627 0.8941
0 0 1
0 1 0
1 1 0
1 0 0
1 0.3804 0];
colormap(mycolor6)

%% 
x_range = linspace(104.5,107,100);
y_range = linspace(24.6,26.2,100);
[lon_plane,lat_plane] = meshgrid(x_range,y_range);
lon_plane = reshape(lon_plane,size(lon_plane,1)*size(lon_plane,2),1);
lat_plane = reshape(lat_plane,size(lat_plane,1)*size(lat_plane,2),1);
out = Edge_Judge(lon_plane,lat_plane,[gx.Lon],[gx.Lat]);
lon_plane(out) = [];
lat_plane(out) = [];
[A,map]=shaperead('黔西南.shp');
[Z]=IDW(lon,lat,ppt,lon_plane,lat_plane);

%% 克里斯金插值法
S=data(:,2:3);
Y=data(:,4);
theta = [10 10]; lob = [1e-1 1e-1]; upb = [20 20];%参数
%调用克里金插值算法工具箱
%进行拟合操作
[mS,mY]=dsmerge(S,Y);
[dmodel, perf] = dacefit(mS, mY, @regpoly0, @corrspherical, theta, lob, upb) ;
m=100;
%插值计算
% X = gridsamp([0 0;100 100], 40);
X = [lon_plane lat_plane];
[YX,MSE] = predictor(X, dmodel);
figure(2)
hold on
geoshow(gx,'FaceColor',[1,1,1],'EdgeColor','black');
scatter(lon_plane, lat_plane, 15, YX, 'filled');
plot(A(1).X,A(1).Y,'-k',A(2).X,A(2).Y,'-k',A(3).X,A(3).Y,'-k',A(4).X,A(4).Y,'-k',A(5).X,A(5).Y,'-k',A(6).X,A(6).Y,'-k',A(7).X,A(7).Y,'-k',A(8).X,A(8).Y,'-k');
colorbar('location', 'southoutside');
% caxis([0 10]);    %colorbar数值范围

color_data = YX;
for i=1:length(YX)
    if color_data(i) <=0
        color_data(i)=0;
    elseif color_data(i)>0 && color_data(i)<=5
        color_data(i)= 5;
    elseif color_data(i)>5 && color_data(i)<=10
        color_data(i)= 10;
    elseif color_data(i)>10 && color_data(i)<=15
        color_data(i)=15;
    elseif color_data(i)>15 && color_data(i)<=20
        color_data(i)=20;
    elseif color_data(i)>20 && color_data(i)<=25
        color_data(i)=25;
    else
        color_data(i)=30;
    end
end
hold on
scatter(lon_plane, lat_plane, 15,color_data , 'filled');
plot(A(1).X,A(1).Y,'-k',A(2).X,A(2).Y,'-k',A(3).X,A(3).Y,'-k',A(4).X,A(4).Y,'-k',A(5).X,A(5).Y,'-k',A(6).X,A(6).Y,'-k',A(7).X,A(7).Y,'-k',A(8).X,A(8).Y,'-k');
colorbar('location', 'southoutside');
mycolor6 = [
0.4784 0.0627 0.8941
0 0 1
0 1 0
1 1 0
1 0 0
1 0.3804 0];
colormap(mycolor6)

%% 
figure(3)   
% sb=[255 255 255;165 243 141;61 185 63;99 184 249;0 0 254;243 5 238;129 0 64]./255;
color_data = Z;
for i=1:length(Z)
    if color_data(i) <=0
        color_data(i)=0;
    elseif color_data(i)>0 && color_data(i)<=5
        color_data(i)= 5;
    elseif color_data(i)>5 && color_data(i)<=10
        color_data(i)= 10;
    elseif color_data(i)>10 && color_data(i)<=15
        color_data(i)=15;
    elseif color_data(i)>15 && color_data(i)<=20
        color_data(i)=20;
    elseif color_data(i)>20 && color_data(i)<=25
        color_data(i)=25;
    else
        color_data(i)=30;
    end
end
hold on
scatter(lon_plane, lat_plane, 15,color_data , 'filled');
plot(A(1).X,A(1).Y,'-k',A(2).X,A(2).Y,'-k',A(3).X,A(3).Y,'-k',A(4).X,A(4).Y,'-k',A(5).X,A(5).Y,'-k',A(6).X,A(6).Y,'-k',A(7).X,A(7).Y,'-k',A(8).X,A(8).Y,'-k');
colorbar('location', 'southoutside');
mycolor6 = [
0.4784 0.0627 0.8941
0 0 1
0 1 0
1 1 0
1 0 0
1 0.3804 0];
colormap(mycolor6)

%% 
figure(3)   
color_data = YX;
for i=1:length(YX)
    if color_data(i) <=0
        color_data(i)=0;
    elseif color_data(i)>0 && color_data(i)<=5
        color_data(i)= 5;
    elseif color_data(i)>5 && color_data(i)<=10
        color_data(i)= 10;
    elseif color_data(i)>10 && color_data(i)<=15
        color_data(i)=15;
    elseif color_data(i)>15 && color_data(i)<=20
        color_data(i)=20;
    elseif color_data(i)>20 && color_data(i)<=25
        color_data(i)=25;
    else
        color_data(i)=30;
    end
end
hold on
scatter(lon_plane, lat_plane, 15,color_data , 'filled');
plot(A(1).X,A(1).Y,'-k',A(2).X,A(2).Y,'-k',A(3).X,A(3).Y,'-k',A(4).X,A(4).Y,'-k',A(5).X,A(5).Y,'-k',A(6).X,A(6).Y,'-k',A(7).X,A(7).Y,'-k',A(8).X,A(8).Y,'-k');
colorbar('location', 'southoutside');
mycolor6 = [
0.4784 0.0627 0.8941
0 0 1
0 1 0
1 1 0
1 0 0
1 0.3804 0];
colormap(mycolor6)

%% 
figure(4)
F = scatteredInterpolant(lon,lat,ppt);
F.Method = 'linear';       % 'linear':线性插值;'nearest':最近邻点插值;'natural':	自然邻点插值
vql = F(lon_plane,lat_plane);
for i=1:length(vql)
    if color_data(i) <=0
        color_data(i)=0;
    elseif color_data(i)>0 && color_data(i)<=5
        color_data(i)= 5;
    elseif color_data(i)>5 && color_data(i)<=10
        color_data(i)= 10;
    elseif color_data(i)>10 && color_data(i)<=15
        color_data(i)=15;
    elseif color_data(i)>15 && color_data(i)<=20
        color_data(i)=20;
    elseif color_data(i)>20 && color_data(i)<=25
        color_data(i)=25;
    else
        color_data(i)=30;
    end
end
scatter(lon_plane, lat_plane, 15,vql , 'filled');
hold on
plot(A(1).X,A(1).Y,'-k',A(2).X,A(2).Y,'-k',A(3).X,A(3).Y,'-k',A(4).X,A(4).Y,'-k',A(5).X,A(5).Y,'-k',A(6).X,A(6).Y,'-k',A(7).X,A(7).Y,'-k',A(8).X,A(8).Y,'-k');
colorbar('location', 'southoutside');
mycolor6 = [
0.4784 0.0627 0.8941
0 0 1
0 1 0
1 1 0
1 0 0
1 0.3804 0];
colormap(mycolor6)

%% 
figure(5)
F = scatteredInterpolant(lon,lat,ppt);
F.Method = 'natural';       % 'linear':线性插值;'nearest':最近邻点插值;'natural':	自然邻点插值
vql_natural = F(lon_plane,lat_plane);
for i=1:length(vql_natural)
    if color_data(i) <=0
        color_data(i)=0;
    elseif color_data(i)>0 && color_data(i)<=5
        color_data(i)= 5;
    elseif color_data(i)>5 && color_data(i)<=10
        color_data(i)= 10;
    elseif color_data(i)>10 && color_data(i)<=15
        color_data(i)=15;
    elseif color_data(i)>15 && color_data(i)<=20
        color_data(i)=20;
    elseif color_data(i)>20 && color_data(i)<=25
        color_data(i)=25;
    else
        color_data(i)=30;
    end
end
scatter(lon_plane, lat_plane, 15,vql , 'filled');
hold on
plot(A(1).X,A(1).Y,'-k',A(2).X,A(2).Y,'-k',A(3).X,A(3).Y,'-k',A(4).X,A(4).Y,'-k',A(5).X,A(5).Y,'-k',A(6).X,A(6).Y,'-k',A(7).X,A(7).Y,'-k',A(8).X,A(8).Y,'-k');
colorbar('location', 'southoutside');
mycolor6 = [
0.4784 0.0627 0.8941
0 0 1
0 1 0
1 1 0
1 0 0
1 0.3804 0];
colormap(mycolor6)
