function [ELEV, LAT, LONG, ...
          decyear, decdoy, year, doy, hour, ZEN, LAI, ...
          Rg, Ta, VPD, PPT, U, ustar, Pa, ea, ...
          Fc, LE, H, Hg, Fc_qc, LE_qc, H_qc, ...
          Tskin, Ts4, Ts8, Ts16, Ts32, Ts64, Ts128, ...
          SWC10, SWC20, SWC30, SWC40, SWC50, SWC60, SWC100, ...
          Rgout, LWin, LWout, Rn] = ...
    LOAD_DATA_SoyAmeriflux(years, doys, laimin, hobs, hcan, z0, d0, vonk, datafile)

    
% Load Soy (Bondville) Ameriflux data
%   - gapfilled .mat data file name is hardcoded

load(datafile);
    
    inds = find(ismember(year_soy, years) & ...
                ismember(doy_soy, doys)  & ...
                LAI_soy >= laimin);
    
    decyear = decyear_soy(inds);
    decdoy = decdoy_soy(inds);
    year = year_soy(inds);
    doy = doy_soy(inds);
    hour = hour_soy(inds);
    ZEN = ZEN_soy(inds);
    LAI = LAI_soy(inds);
    
    Ta = Ta_soy(inds);
    VPD = VPD_soy(inds);
    PPT = PPT_soy(inds);
    U = U_soy(inds);
    ustar = ustar_soy(inds);
    Pa = Pa_soy(inds);
    ea = ea_soy(inds);
    
    Fc = Fc_soy(inds);
    LE = LE_soy(inds);
    H = H_soy(inds);
    Hg = Hg_soy(inds);
    
    Fc_qc = Fc_qc_soy(inds);
    LE_qc = LE_qc_soy(inds);
    H_qc = H_qc_soy(inds);
    
    Tskin = Tskin_soy(inds);
    Ts4 = Ts4_soy(inds);
    Ts8 = Ts8_soy(inds);
    Ts16 = Ts16_soy(inds);
    Ts32 = Ts32_soy(inds);
    Ts64 = Ts64_soy(inds);
    Ts128 = Ts128_soy(inds);
            
    SWC10 = SWC10_soy(inds);
    SWC20 = SWC20_soy(inds);
    SWC30 = SWC30_soy(inds);
    SWC40 = SWC40_soy(inds);
    SWC50 = SWC50_soy(inds);
    SWC60 = SWC60_soy(inds);
    SWC100 = SWC100_soy(inds);

    Rg = Rg_soy(inds);
    Rgout = Rgout_soy(inds);
    LWin = LWin_soy(inds);
    LWout = LWout_soy(inds);
    Rn = Rn_soy(inds);
    
% Calculate Vapor Variables
    aa = 0.611;  % [kPa]
    bb = 17.502;
    cc = 240.97; % [C]
    esat = aa*exp((bb*Ta)./(cc+Ta));
    ean = esat - VPD;
    hr = ea./esat;
    
% Data Corrections    
    uinds = find(U<0.1);
    U(uinds) = 0.1;
    
% Calculate ustar for missing periods
    binds = find(isnan(ustar) | ustar<=0);
    ustar(binds) = vonk.*U(binds)./(log((hobs-d0)/z0));
    
% Adjust U from measurement height to canopy height (Brutsaert, 4.2)
    U = U - (ustar/vonk).*log(hobs/hcan);
    uinds = find(U<0.1);
    U(uinds) = 0.1;
    
% Downward LW - eliminate pre-2005.5 data as they appear to be filled with
% low values
%    binds = find(decyear<2005.5);
%    LWin(binds) = NaN;
%LWin = NaN(size(LWin));          
          
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% FILL Measured Hg with Linear fit of Hg to Rg
% --> Using Hg to force soil heat transfer model
    ginds = find(~isnan(Hg) & ~isnan(Rg));
    [lps] = polyfit(Rg(ginds), Hg(ginds), 1);
    aa = lps(1); bb = lps(2);
    binds = find(isnan(Hg));
    Hg(binds) = aa*Rg(binds) + bb;
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
          
          
          
          
          
          