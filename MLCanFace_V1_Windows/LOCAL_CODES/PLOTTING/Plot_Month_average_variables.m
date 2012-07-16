figure(1);
x=[0:0.5:23.5]; 
%----------------------------------------
%subplot(2,3,1);
%hold on;
%grid on;

%plot(x,CO_MON6_LE_diurnal_can,'-b');
%plot(x,MG_MON6_LE_diurnal_can,'--k');
%plot(x,SW_MON6_LE_diurnal_can,'-.r');

%title('Latent heat for 3 plants in June');
%xlabel('hours');
%ylabel('LE [\mumol m^{-2} s^{-1}]');

%----------------------------------------
subplot(2,2,1);
hold on;
grid on;

plot(x,CO_MON7_LE_diurnal_can,'-b');
plot(x,MG_MON7_LE_diurnal_can,'--k');
plot(x,SW_MON7_LE_diurnal_can,'-.r');

title('\bf Diurnally averaged Latent heat in July 2005');
xlabel('hours');
ylabel('LE [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');
%----------------------------------------
subplot(2,2,2);
hold on;
grid on;

plot(x,CO_MON8_LE_diurnal_can,'-b');
plot(x,MG_MON8_LE_diurnal_can,'--k');
plot(x,SW_MON8_LE_diurnal_can,'-.r');

title('\bf Diurnally averaged Latent heat in August 2005');
xlabel('hours');
ylabel('LE [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');
%----------------------------------------
%subplot(2,2,3);
%hold on;
%grid on;

%plot(x,CO_MON6_H_diurnal_can,'-b');
%plot(x,MG_MON6_H_diurnal_can,'--k');
%plot(x,SW_MON6_H_diurnal_can,'-.r');

%title('Sensible heat for 3 plants in June');
%xlabel('hours');
%ylabel('H [\mumol m^{-2} s^{-1}]');

%----------------------------------------
subplot(2,2,3);
hold on;
grid on;

plot(x,CO_MON7_H_diurnal_can,'-b');
plot(x,MG_MON7_H_diurnal_can,'--k');
plot(x,SW_MON7_H_diurnal_can,'-.r');

title('\bf Diurnally averaged Sensible heat in July 2005');
xlabel('hours');
ylabel('H [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');
%----------------------------------------
subplot(2,2,4);
hold on;
grid on;

plot(x,CO_MON8_H_diurnal_can,'-b');
plot(x,MG_MON8_H_diurnal_can,'--k');
plot(x,SW_MON8_H_diurnal_can,'-.r');

title('\bf Diurnally averaged Sensible heat in August 2005');
xlabel('hours');
ylabel('H [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');

%-------------------------------------------------------------------------%
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%
%-------------------------------------------------------------------------%
figure(2);
x=[0:0.5:23.5]; 

%subplot(2,3,4);
%hold on;
%grid on;

%plot(x,CO_MON6_Rnrad_diurnal_can,'-b');
%plot(x,MG_MON6_Rnrad_diurnal_can,'--k');
%plot(x,SW_MON6_Rnrad_diurnal_can,'-.r');

%title('Net Radiation for 3 plants in June');
%xlabel('hours');
%ylabel('Rn [W m^{-2}]');

%----------------------------------------
subplot(2,2,1);
hold on;
grid on;

plot(x,CO_MON7_Rnrad_diurnal_can,'-b');
plot(x,MG_MON7_Rnrad_diurnal_can,'--k');
plot(x,SW_MON7_Rnrad_diurnal_can,'-.r');

title('\bf Diurnally averaged Net radiation in July 2005');
xlabel('hours');
ylabel('Rn [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');

%----------------------------------------
subplot(2,2,2);
hold on;
grid on;

plot(x,CO_MON8_Rnrad_diurnal_can,'-b');
plot(x,MG_MON8_Rnrad_diurnal_can,'--k');
plot(x,SW_MON8_Rnrad_diurnal_can,'-.r');

title('\bf Diurnally averaged Net radiation in August 2005');
xlabel('hours');
ylabel('Rn [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');

%----------------------------------------
%subplot(2,2,3);
%hold on;
%grid on;

%plot(x,CO_MON6_An_diurnal_can,'-b');
%plot(x,MG_MON6_An_diurnal_can,'--k');
%plot(x,SW_MON6_An_diurnal_can,'-.r');

%title('An for 3 plants in June');
%xlabel('hours');
%ylabel('An [\mumol m^{-2} s^{-1}]');

%----------------------------------------
subplot(2,2,3);
hold on;
grid on;

plot(x,CO_MON7_An_diurnal_can,'-b');
plot(x,MG_MON7_An_diurnal_can,'--k');
plot(x,SW_MON7_An_diurnal_can,'-.r');

title('\bf Diurnally averaged Net Photosynthesis in July 2005');
xlabel('hours');
ylabel('An [\mumol m^{-2} s^{-1}]');
axis([0,24,-10,40]);
legend('Corn','Miscan','Switch');
%----------------------------------------
subplot(2,2,4);
hold on;
grid on;

plot(x,CO_MON8_An_diurnal_can,'-b');
plot(x,MG_MON8_An_diurnal_can,'--k');
plot(x,SW_MON8_An_diurnal_can,'-.r');

title('\bf Diurnally averaged Net Photosynthesis in Augst 2005');
xlabel('hours');
ylabel('An [\mumol m^{-2} s^{-1}]');
axis([0,24,-10,40]);
legend('Corn','Miscan','Switch');

%-------------------------------------------------------------------------%
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%
%-------------------------------------------------------------------------%
figure(3);
x=[0:0.5:23.5]; 

%----------------------------------------
%subplot(2,3,1);
%hold on;
%grid on;

%plot(x,CO_MON6_G_diurnal_can,'-b');
%plot(x,MG_MON6_G_diurnal_can,'--k');
%plot(x,SW_MON6_G_diurnal_can,'-.r');

%title('Soil heat for 3 plants in June');
%xlabel('hours');
%ylabel('G [W m^{-2}]');

%----------------------------------------
subplot(2,2,1);
hold on;
grid on;

plot(x,CO_MON7_G_diurnal_can,'-b');
plot(x,MG_MON7_G_diurnal_can,'--k');
plot(x,SW_MON7_G_diurnal_can,'-.r');

title('\bf Diurnally averaged Soil heat in July 2005');
xlabel('hours');
ylabel('G [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');
%----------------------------------------
subplot(2,2,2);
hold on;
grid on;

plot(x,CO_MON8_G_diurnal_can,'-b');
plot(x,MG_MON8_G_diurnal_can,'--k');
plot(x,SW_MON8_G_diurnal_can,'-.r');

title('\bf Diurnally averaged Soil heat in July 2005');
xlabel('hours');
ylabel('G [W m^{-2}]');
axis([0,24,-100,500]);
legend('Corn','Miscan','Switch');
%----------------------------------------
