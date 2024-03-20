//==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+
//
//  B40% projection model accounting for discarding for AK Sablefish
//  Developed to inform NPFMC council motion to allow sablefish discarding
//  Alaska Fisheries Science Center, March 2024
//  Daniel Goethel, daniel.goethel@noaa.gov
//
//==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+

// Single Area (combined across GOA, BS, AI)
// Split sexes with input sex-specific selectivty, weight-at-age (from most recent time block in 2023 assessment)

// fixed_gear_fish = combined (LL hooks and pots) fixed gear fishery     (logistic selectivity; assumes recent, post-2016, time block from 2023 assessment)
// trawl_gear_fish = trawl fishery                                       (GAMMA FUNCTION selectivity)

// fixed_gear_disc = discards from the fixed gear fishery based on input retention fxn (all trawl catch assumed dead, no discards modeled)

//==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+

GLOBALS_SECTION
  #include "admodel.h"
  #include "statsLib.h"
  #include "qfclib.h"
  #include <contrib.h>
  #define EOUT(var) cout <<#var<<" "<<var<<endl;

DATA_SECTION
    
// Start and end years, recruitment age, number of ages
  init_int styr;                                    // start year for projections 
  init_int endyr;                                   // end year for projections
  init_int recage;                                  // assumed age of reccruitment; NOTE: not used in the model, but should be accounted for in subsequent figures of results
  init_int nages;                                   // number of ages to model
  int nyrs;
            !!  nyrs = endyr - styr + 1;
  int nyrs_half;
            !!  nyrs_half = round((endyr - styr)*0.5) + 1;

// switches and definitions for inputs/assumptions
  init_number do_full_YPR_switch;                   // whether or not to do the full loop over Fs of YPR/SPR/RPR calcs
                                                           // ==0, skip (no calcs)
                                                           // ==1, do YPR calcs
  init_number harvest_fract_switch;                 // whether the full ABC should be harvested or not:
                                                           // ==1 full ABC
                                                           // ==2 only partial ABC utilization based on harvest_prop
  init_number retention_type;                       // form of retention fxn:
                                                           // ==1 knife edge at age
                                                           // ==2 logistic
  init_number recruit_type;                         // how to simulate recruitment:
                                                           // ==1 use bootstrapping from the SAFE recruitment time series to sim recruitment, recruitment pattern determined by recruit_pattern
                                                           // ==2 input recruitment values directly using input_rec vector
                                                           // ==3 simulate from a distribution (NOT IMPLEMENTED)
  init_number recruit_pattern;                      // when recruitment_type ==1, recruitment is chosen from the bootstrapped recruitment based on the:
                                                           // ==1 full time series of recruitment from SAFE
                                                           // ==2 recent time series from SAFE (2014+)
                                                           // ==3 (low-hi pattern) full recruitment time series for first half of time series, recent recruitment time series for second half of time series
                                                           // ==4 (hi-low pattern) recent recruitment time series for first half of time series, full recruitment time series for second half of time series
  init_number recruit_regime_shift;                 // method for calculating the B40% reference point from the SPR value:
                                                           // ==1 (status quo used for NPFMC B40% projections) no regime shift (multiply SPR by long-term mean recruitment),
                                                           // ==2 assume regime shift (multiply SPR by recent, 2014+,  mean recruitment)
  init_number M_type;                               // define variability in M:
                                                           // ==1 input M as a constant
                                                           // ==2 age-varying
  init_number HCR_type;                             // the HCR used to calculate ABC:
                                                           // ==1 (status quo) use the default B40% NPFMC HCR
                                                           // ==2 (developmental) capped HCR (use the B40% HCR if B<B40%, but set F to derived F that attains landings_cap otherwise); cap for FG landings ONLY
                                                           // ==3 (developmental) capped HCR (use the B40% HCR if B<B40%, but set F to derived F that attains landings_cap otherwise); cap for FG+trawl landings ONLY
  init_number price_type;                           // correlation of price with ABC:
                                                           // ==1, (status quo) price is constant based in input price
                                                           // ==2, price is constant at recent average
                                                           // ==3 (developmental) linear increase in price to 2017 max prices as move towards 2017 landings

// YPR calc inputs (when do_full_YPR_switch==1)
  init_number F_YPR_start;                          // starting value for YPR F calcs
  init_number F_YPR_end;                            // ending value for YPR F calcs
  init_number n_F_incr_ypr;                         // number steps in F for YPR, defines increment size in F; NOTE: need to add 1 to number of increments to account for starting value if want to actually end with the F_YPR_end value
  number YPR_F_step
            !! YPR_F_step = (F_YPR_end-F_YPR_start)/(n_F_incr_ypr-1);     // calculate step size, use n_F_incr_ypr-1 because number of steps should be adjust up by 1 to ensure get to F_YPR_end value

// Biological inputs
  init_number spawn_month;                          // Spawning Month
  number spawn_fract
            !! spawn_fract = (spawn_month-1)/12;
  init_vector p_mature(1,nages);                    // maturity
  init_vector wt_m(1,nages);                        // weight males 
  init_vector wt_f(1,nages);                        // weight females 
  init_number prop_m;                               // proportion of males in pop
  init_number M_cnst;                               // natural mortality when constant when M_type ==1
  init_vector M_age(1,nages);                       // Natural mortality by age when M_type ==2

// Recruitment and abundance  pars
  init_number nyrs_SAFE_rec_full;                   // number of years of recruitment to read from SAFE
  init_number nyrs_SAFE_rec_recent;                 // recent number of years of recruitment to read from SAFE (2014 cohort+)
  init_vector rec_full(1,nyrs_SAFE_rec_full);       // the full time series of recruitment from the SAFE
  init_vector rec_recent(1,nyrs_SAFE_rec_recent);   // the recent time series of recruitment from the SAFE
  init_vector input_rec(1,nyrs);                          // time series of recruitment inputs when recruitment_type ==2
  init_number mean_rec_full;                        // the average recruitment value (long-term mean) for the normal distribution when recruitment_type ==3
  init_number mean_rec_recent;                      // the average recruitment value (recent mean) for the normal distribution when recruitment_type ==3
  init_number stdev_rec_full;                       // the standard deviation of recruitment (long-term) for the normal distribution when recruitment_type ==3
  init_number stdev_rec_recent;                     // the standard deviation of recruitment (recent) for the normal distribution when recruitment_type ==3
  init_vector init_abund_f(1,nages);                // initial abundance females                     
  init_vector init_abund_m(1,nages);                // initial abundance males
  
// F and Slx pars
  init_vector ABC_SAFE(1,3);                        // last three ABCs from most recent SAFE (terminal year and 2 projected ABCs)
  init_number landings_SAFE;                        // total landings from the last SAFE (which survival and abund calcs in terminal year are based on)
  init_number landings_cap;                         // when HCR_type==2, set the max landings by fixed gear fleet to this value
  init_number harvest_prop_input;                   // when harvest_fract_switch==2, determines the proportion of ABC to be harvested
  init_number fract_trawl;                          // fraction of F from trawl gear
  init_number log_FG_a50_f;                         // female fixed gear fishery age at 50% selection                                                   
  init_number log_FG_delta_f;                       // female fixed gear fishery age between 50% selection and 95% selection....
  init_number log_FG_a50_m;                         // male fixed gear fishery age at 50% selection                                                   
  init_number log_FG_delta_m;                       // male fixed gear fishery age between 50% selection and 95% selection....
  init_number log_trawl_a50_f;                      // female trawl gear fishery age at 50% selection                                                   
  init_number log_trawl_delta_f;                    // female trawl gear fishery age between 50% selection and 95% selection....
  init_number log_trawl_a50_m;                      // male trawl gear fishery age at 50% selection                                                   
  init_number log_trawl_delta_m;                    // male trawl gear fishery age between 50% selection and 95% selection....
  init_vector S_f_SAFE_term(1,nages);               // female survival during SAFE terminal year to get abundance in start of projection
  init_vector S_m_SAFE_term(1,nages);               // male survival during SAFE terminal year to get abundance in start of projection

// Retention and DMR pars
  init_number ret_age_f;                            // female age that start retaining fish when retention type ==1, NOTE: this is actual age minus 1 because model running from age 1 (==real age-2)
  init_number ret_a50_f;                            // female retention logistic fxn age at 50% retention when retention type ==2, NOTE: this is actual age minus 1 because model running from age 1 (==real age-2) 
  init_number ret_delta_f;                          // female retention logistic fxn age between 50% retention and 95% retention when retention type ==2
  init_number ret_age_m;                            // male age that start retaining fish when retention type ==1, NOTE: this is actual age minus 1 because model running from age 1 (==real age-2)
  init_number ret_a50_m;                            // male retention logistic fxn age at 50% retention when retention type ==2, NOTE: this is actual age minus 1 because model running from age 1 (==real age-2)
  init_number ret_delta_m;                          // male retention logistic fxn age between 50% retention and 95% retention when retention type ==2,
 
  init_number DMR_f;                                // female discard mortality rate
  init_number DMR_m;                                // male discard mortality rate

// Price pars
  init_vector price_age_f(1,nages);                 // when price_type==1, price per kg at each age females
  init_vector price_age_m(1,nages);                 // when price_type==1, price per kg at each age females
  init_vector price_age_f_avg(1,nages);             // when price_type==2, price per kg at each age females
  init_vector price_age_m_avg(1,nages);             // when price_type==2, price per kg at each age females
  init_number land_price_max;                       // when price_type==3, the landings associated with the maximum price (e.g., 2017)
  init_vector max_price_f(1,nages);                 // when price_type==3, sets the maximum price
  init_vector max_price_m(1,nages);                 // when price_type==3, sets the maximum price

// Newton-Raphson parameters for HCR_type==2 or HCR_type==3
  init_number max_Fnew                              // maximum F during NR search
  init_number Fnew_start                            // starting F for NR search
  init_int NR_iterations                            // number of NR iterations to derive F for desired landings
  init_number NR_dev                                // size of step/deviation when doing iterative NR search for F

// Random number inputs and debug 
  init_number RNG_seed_rec_full;                    // seed for random number generator for recruitment from full time series
  init_number RNG_seed_rec_recent;                  // seed for random number generator for recruitment from recent time series
  init_number debug_end;

     !! cout<<"This is the end (of the data == 666)..."<<debug_end<<endl;

// Initialize some index variables
 int k
 int i
 int j
 ivector RNG_recent(1,nyrs)
 ivector RNG_full(1,nyrs)

 PARAMETER_SECTION

  vector yrs(1,nyrs);

///////////////////////////////////////////
/// Estimated parameters for calculating SPR
//////////////////////////////////////////

  init_bounded_number log_mF50(-5,0.5)              // Estimated F50 
  init_bounded_number log_mF40(-5,0.5)              // Estimated F40 
  init_bounded_number log_mF35(-5,0.5)              // Estimated F35

// Define an objective function
  objective_function_value obj_fun;                 // Total likelihood for objective function value
  number sprpen                                     // Likelihood penalty to make ADMB estimate spr rates

///////////////////////////////////////////
/// Biological values
//////////////////////////////////////////

  matrix weight_f(1,nyrs,1,nages)
  matrix weight_m(1,nyrs,1,nages)
  matrix maturity(1,nyrs,1,nages)
  matrix weight_mat_prod_f(1,nyrs,1,nages);        // Weight of mature fish 
  matrix M(1,nyrs,1,nages);                        // Natural mortality by year and age

///////////////////////////////////////////
/// Selectivity values
//////////////////////////////////////////

  number FG_a50_f;                                  // female fixed gear fishery age at 50% selection                                                   
  number FG_delta_f;                                // female fixed gear fishery age between 50% selection and 95% selection
  number FG_a50_m;                                  // male fixed gear fishery age at 50% selection                                                   
  number FG_delta_m;                                // male fixed gear fishery age between 50% selection and 95% selection
  number trawl_a50_f;                               // female trawl gear fishery age at 50% selection                                                   
  number trawl_delta_f;                             // female trawl gear fishery age between 50% selection and 95% selection
  number trawl_a50_m;                               // male trawl gear fishery age at 50% selection                                                   
  number trawl_delta_m;                             // male trawl gear fishery age between 50% selection and 95% selection

  vector slx_FG_f(1,nages);                         // female fixed gear selectivity at age
  vector slx_FG_m(1,nages);                         // male fixed gear selectivity at age
  vector slx_trawl_f(1,nages);                      // female trawl gear selectivity at age
  vector slx_trawl_m(1,nages);                      // male trawl gear selectivity at age

///////////////////////////////////////////
/// Retention values
//////////////////////////////////////////

  vector ret_f(1,nages)                             // female retention at age for the fixed gear fleet
  vector ret_m(1,nages)                             // male retention at age for the fixed gear fleet

///////////////////////////////////////////
/// SPR projection values
//////////////////////////////////////////

  number F50;                                       // fully selected log transformed F to achieve B50                     
  number F40;                     
  number F35;                                             
  number mF50;                                      // log transformed F to achieve B50
  number mF40;
  number mF35;
  number SB0                                        // Spawning biomass at no fishing
  number SBF50                                      // " " at F50
  number SBF40                                      // " " at F40
  number SBF35                                      // " " at F35
  matrix Nspr(1,4,1,nages)                          // Matrix of number of spawners at age at each fishing mortality level
  number B40                                        // the actual SSB40% (SPR40%*avg_recr)
  number B35                                        // the actual SSB35% (SPR35%*avg_recr), associated with FOFL
  number B0                                         // the actual SSB100% (SPR100%*avg_recr), associated with virgin conditions (no fishing)

///////////////////////////////////////////
/// Full YRP projection values
//////////////////////////////////////////

  number Fmax_ypr                                   // F that maximized YPR
  number ypr_Fmax                                   // YPR at F_max
  number spr_Fmax                                   // SPR at F_max
  number rpr_Fmax_curr                              // revenue-per-recruit (RPR) at Fmax based on current prices
  number rpr_Fmax_avg                               // revenue-per-recruit (RPR) at Fmax based on average prices
  number rpr_Fmax_max                               // revenue-per-recruit (RPR) at Fmax based on max prices
  number loc_Fmax                                   // index location of Fmax
  
  number ypr_F40                                    // YPR at F_40
  number F_F40                                      // F at F_40 for the loop (unofficial)
  number spr_F40                                    // SPR at F_40
  number rpr_F40_curr                               // revenue-per-recruit (RPR) at F40 based on current prices
  number rpr_F40_avg                                // revenue-per-recruit (RPR) at F40 based on average prices
  number rpr_F40_max                                // revenue-per-recruit (RPR) at F40 based on max prices
  number loc_F40                                    // index location of F40

  number F_max_rpr_curr                             // F that maximized RPR at current prices
  number ypr_max_rpr_curr                           // YPR at max RPR_curr
  number spr_max_rpr_curr                           // SPR at max RPR_curr
  number rpr_max_curr                               // revenue-per-recruit (RPR) at max RPR_curr
  number loc_rpr_curr_max                           // index location of F at max RPR_curr

  number F_max_rpr_avg                              // F that maximized RPR at max prices
  number ypr_max_rpr_avg                            // YPR at max RPR_max
  number spr_max_rpr_avg                            // SPR at max RPR_max
  number rpr_max_avg                                // revenue-per-recruit (RPR) at max RPR_max
  number loc_rpr_avg_max                           // index location of F at max RPR_max

  number F_max_rpr_max                              // F that maximized RPR at avg prices
  number ypr_max_rpr_max                            // YPR at max RPR_avg
  number spr_max_rpr_max                            // SPR at max RPR_avg
  number rpr_max_max                                // revenue-per-recruit (RPR) at max RPR_avg
  number loc_rpr_max_max                           // index location of F at max RPR_avg

  vector F_YPR(1,n_F_incr_ypr)                      // F values for YPR calculations
  vector ypr(1,n_F_incr_ypr)                        // YPR at each F
  vector spr(1,n_F_incr_ypr)                        // SPR at each F
  vector rpr_curr(1,n_F_incr_ypr)                   // RPR at each F for current prices
  vector rpr_avg(1,n_F_incr_ypr)                    // RPR at each F for average prices
  vector rpr_max(1,n_F_incr_ypr)                    // RPR at each F for max prices

  vector ypr_f40_age(1,nages)                       // YPR age curve at F40
  vector spr_f40_age(1,nages)                       // SPR age curve at F40
  vector rpr_f40_age_curr(1,nages)                  // RPR age curve at F40 for current prices
  vector rpr_f40_age_avg(1,nages)                   // RPR age curve at F40 for average prices
  vector rpr_f40_age_max(1,nages)                   // RPR age curve at F40 for max prices

  matrix N_YPR_f(1,n_F_incr_ypr,1,nages)            // abundance-at-age at each F value for YPR/SPR
  matrix N_YPR_m(1,n_F_incr_ypr,1,nages)            // abundance-at-age at each F value for YPR/SPR
  matrix YPR_m(1,n_F_incr_ypr,1,nages)              // YPR-at-age at each F value
  matrix YPR_f(1,n_F_incr_ypr,1,nages)              // YPR-at-age at each F value
  matrix YPR(1,n_F_incr_ypr,1,nages)                // YPR-at-age at each F value
  matrix SPR(1,n_F_incr_ypr,1,nages)                // SPR-at-age at each F value
  matrix RPR_curr(1,n_F_incr_ypr,1,nages)           // RPR-at-age at each F value for current prices
  matrix RPR_avg(1,n_F_incr_ypr,1,nages)            // RPR-at-age at each F value for average prices
  matrix RPR_max(1,n_F_incr_ypr,1,nages)            // RPR-at-age at each F value for max prices

///////////////////////////////////////////
/// Population projection values
//////////////////////////////////////////

  number harvest_prop;                              // whether full ABC is harvested or only some input portion of it (determines realized F each year), defined by harvest_fract_switch
  vector FABC(1,nyrs);                              // yearly F to get ABC
  matrix FABC_age_f(1,nyrs,1,nages);                // female F associated with all fishery dead fish (landed+dead discards)
  matrix FABC_age_m(1,nyrs,1,nages);                // male F associated with all fishery dead fish (landed+dead discards)

  vector FOFL(1,nyrs);                              // yearly F to get OFL (F35)
  matrix FOFL_age_f(1,nyrs,1,nages);
  matrix FOFL_age_m(1,nyrs,1,nages);

  matrix N_proj_f(1,nyrs,1,nages);                  // female Projected numbers-at-age
  matrix N_proj_m(1,nyrs,1,nages);                  // male Projected numbers-at-age
  matrix N_proj_tot(1,nyrs,1,nages);                // total abundance-at-age summed across sexes
  vector N(1,nyrs)                                  // total abundance summed across ages and sexes
  matrix ssb_age(1,nyrs,1,nages);                   // ssb at each age
  vector ssb(1,nyrs);                               // total ssb
  vector bio(1,nyrs);                               // total biomass
  vector recruits(1,nyrs);                          // total recruitment

  vector F(1,nyrs);                                 // yearly fully selected realized F
  vector F_cap_adj_FG(1,nyrs);                      // when HCR_type==2 or HCR_type==3, adjustment to F based on ratio of ABC_cap to previous year's landings
  vector F_cap_adj_tr(1,nyrs);                      // when HCR_type==3, adjustment to F based on ratio of ABC_cap to previous year's landings
  matrix F_age_f(1,nyrs,1,nages);                   // female realized F, discounted for porportion of ABC harvested
  matrix F_age_m(1,nyrs,1,nages);
  matrix Z_F_f(1,nyrs,1,nages);                     // female total mortality at realized F
  matrix Z_F_m(1,nyrs,1,nages);
  matrix Z_ABC_f(1,nyrs,1,nages);                   // female total mortality at ABC
  matrix Z_ABC_m(1,nyrs,1,nages);
  matrix Z_OFL_f(1,nyrs,1,nages);                   // female total mortality at OFL
  matrix Z_OFL_m(1,nyrs,1,nages);

  matrix CAA_dead_f(1,nyrs,1,nages);                // female catch-at-age total dead fish due to fishing at realized F
  matrix CAA_dead_m(1,nyrs,1,nages);                // male catch-at-age total dead fish due to fishing at realized F
  matrix CAA_landed_FG_f(1,nyrs,1,nages);           // female catch-at-age landed dead fish due to fixed gear fishing at realized F
  matrix CAA_landed_FG_m(1,nyrs,1,nages);           // male catch-at-age landed dead fish due to fixed gear fishing at realized F
  matrix CAA_landed_trwl_f(1,nyrs,1,nages);         // female catch-at-age landed dead fish due to trawl gear fishing at realized F
  matrix CAA_landed_trwl_m(1,nyrs,1,nages);         // male catch-at-age landed dead fish due to trawl gear fishing at realized F

  matrix CAA_ABC_dead_f(1,nyrs,1,nages);            // female catch-at-age total dead fish due to fishing at ABC
  matrix CAA_ABC_dead_m(1,nyrs,1,nages);            // male catch-at-age total dead fish due to fishing at ABC
  matrix CAA_ABC_landed_FG_f(1,nyrs,1,nages);       // female catch-at-age landed dead fish due to fixed gear fishing at ABC
  matrix CAA_ABC_landed_FG_m(1,nyrs,1,nages);       // male catch-at-age landed dead fish due to fixed gear fishing at ABC
  matrix CAA_ABC_landed_trwl_f(1,nyrs,1,nages);     // female catch-at-age landed dead fish due to trawl gear fishing at ABC
  matrix CAA_ABC_landed_trwl_m(1,nyrs,1,nages);     // male catch-at-age landed dead fish due to trawl gear fishing at ABC

  matrix CAA_OFL_dead_f(1,nyrs,1,nages);            // female catch-at-age total dead fish due to fishing at OFL
  matrix CAA_OFL_dead_m(1,nyrs,1,nages);            // male catch-at-age total dead fish due to fishing at OFL
  matrix CAA_OFL_landed_FG_f(1,nyrs,1,nages);       // female catch-at-age landed dead fish due to fixed gear fishing at OFL
  matrix CAA_OFL_landed_FG_m(1,nyrs,1,nages);       // male catch-at-age landed dead fish due to fixed gear fishing at OFL
  matrix CAA_OFL_landed_trwl_f(1,nyrs,1,nages);     // female catch-at-age landed dead fish due to trawl gear fishing at OFL
  matrix CAA_OFL_landed_trwl_m(1,nyrs,1,nages);     // male catch-at-age landed dead fish due to trawl gear fishing at OFL

  matrix DAA_dead_f(1,nyrs,1,nages);                // female dead discards-at-age due to fishing at realized F
  matrix DAA_dead_m(1,nyrs,1,nages);                // male dead discards-at-age due to fishing at realized F
  matrix DAA_f(1,nyrs,1,nages);                     // female total discards-at-age due to fishing at realized F
  matrix DAA_m(1,nyrs,1,nages);                     // male total discards-at-age due to fishing at realized F

  matrix DAA_ABC_dead_f(1,nyrs,1,nages);            // female dead discards-at-age due to fishing at ABC
  matrix DAA_ABC_dead_m(1,nyrs,1,nages);            // male dead discards-at-age due to fishing at ABC
  matrix DAA_ABC_f(1,nyrs,1,nages);                 // female total discards-at-age due to fishing at ABC
  matrix DAA_ABC_m(1,nyrs,1,nages);                 // male total discards-at-age due to fishing at ABC
 
  matrix DAA_OFL_dead_f(1,nyrs,1,nages);            // female dead discards-at-age due to fishing at OFL
  matrix DAA_OFL_dead_m(1,nyrs,1,nages);            // male dead discards-at-age due to fishing at OFL
  matrix DAA_OFL_f(1,nyrs,1,nages);                 // female total discards-at-age due to fishing at OFL
  matrix DAA_OFL_m(1,nyrs,1,nages);                 // male total discards-at-age due to fishing at OFL
 
  vector dead_removals(1,nyrs);                      // total dead fish (in weight) due to fishing at realized F
  vector dead_removals_ABC(1,nyrs);                  // total dead fish (in weight) due to fishing at ABC
  vector dead_removals_OFL(1,nyrs);                  // total dead fish (in weight) due to fishing at OFL

  vector landings_FG(1,nyrs);                       // total landings from fixed gear fleet (in weight) due to fishing at realized F
  vector landings_FG_ABC(1,nyrs);                   // total landings from fixed gear fleet (in weight) due to fishing at ABC
  vector landings_FG_OFL(1,nyrs);                   // total landings from fixed gear fleet (in weight) due to fishing at OFL

  vector landings_trawl(1,nyrs);                    // total landings from trawl gear fleet (in weight) due to fishing at realized F
  vector landings_trawl_ABC(1,nyrs);                // total landings from trawl gear fleet (in weight) due to fishing at ABC
  vector landings_trawl_OFL(1,nyrs);                // total landings from trawl gear fleet (in weight) due to fishing at OFL

  vector landings_tot(1,nyrs);                      // total landings summed across fleets (in weight) due to fishing at realized F
  vector landings_tot_ABC(1,nyrs);                  // total landings summed across fleets (in weight) due to fishing at ABC
  vector landings_tot_OFL(1,nyrs);                  // total landings summed across fleets (in weight) due to fishing at OFL

  vector disc(1,nyrs);                              // total discards from fixed gear fleet (in weight) due to fishing at realized F
  vector disc_ABC(1,nyrs);                          // total discards from fixed gear fleet (in weight) due to fishing at ABC
  vector disc_OFL(1,nyrs);                          // total discards from fixed gear fleet (in weight) due to fishing at OFL

  vector dead_disc(1,nyrs);                         // dead discards from fixed gear fleet (in weight) due to fishing at realized F
  vector dead_disc_ABC(1,nyrs);                     // dead discards from fixed gear fleet (in weight) due to fishing at ABC
  vector dead_disc_OFL(1,nyrs);                     // dead discards from fixed gear fleet (in weight) due to fishing at OFL

  matrix revenue_age(1,nyrs,1,nages);               // revenue at age for fixed gear fleet landings due to fishing at realized F
  matrix revenue_age_ABC(1,nyrs,1,nages);           // revenue at age for fixed gear fleet landings due to fishing at ABC
  matrix revenue_age_OFL(1,nyrs,1,nages);           // revenue at age for fixed gear fleet landings due to fishing at OFL

  vector revenue(1,nyrs);                           // total revenue for fixed gear fleet landings due to fishing at realized F
  vector revenue_ABC(1,nyrs);                       // total revenue for fixed gear fleet landings due to fishing at ABC
  vector revenue_OFL(1,nyrs);                       // total revenue for fixed gear fleet landings due to fishing at OFL

  matrix price_age_scaled_f(1,nyrs,1,nages)         // if price_type==2, then calculate the new scaled prices
  matrix price_age_scaled_m(1,nyrs,1,nages)         // if price_type==2, then calculate the new scaled prices

///////////////////////////////////////////
/// Newton-Raphson STuff
//////////////////////////////////////////

  vector fof_f(1,nages)
  vector fof_m(1,nages)
  number landings_fof
  vector fof_f_hi(1,nages)
  vector fof_m_hi(1,nages)
  number landings_fof_hi
  vector fof_f_lo(1,nages)
  vector fof_m_lo(1,nages)
  number landings_fof_lo
  number fofF
  number fprimeF
  number F_new
  number delt
  
///////////////////////////////////////////
/// RNG containers
//////////////////////////////////////////

  vector RNG_vec_full(1,nyrs)
  vector RNG_vec_recent(1,nyrs)
  
     !! cout<<"This is the end (of the parameters)..."<<endl;

 PROCEDURE_SECTION

  Get_RNGs();                                       // set random numbers and assign to vectors
  Get_Biologicals();                                // get biological inputs
  Get_Selectivity_Retention();                      // Call function to get selectivities
  Compute_B40();                                    // Compute f40 etc.
  Compute_YPR();                                     // calculate YPR, SPR, and revenue per recruit
  Get_Population_Projection();                      // do projection
  Evaluate_Objective_Function();                    // Minimize objective function value

FUNCTION Get_RNGs

     // create RNG and fill vector with bootstrapped (sampled) values from a time series of recruitment values estimated from SAFE (either full time series or only recent time series)
  random_number_generator RNG_full_init(RNG_seed_rec_full);              // set the RNG based on the input seed value
  random_number_generator RNG_recent_init(RNG_seed_rec_recent);          
  RNG_full = sample(rec_full,nyrs,1,RNG_full_init);                      // sample with replacement from the recruitment time series (based on random uniform number), this provides the index of the recruitment vector to sample
  RNG_recent = sample(rec_recent,nyrs,1,RNG_recent_init);

  for(i=1;i<=nyrs;i++)
   {
    RNG_vec_full(i)=rec_full(RNG_full(i));                               // use the location of recruitment to sample to actually grab that recruitment and save as vector to use in projections
    RNG_vec_recent(i)=rec_recent(RNG_recent(i));
   }

FUNCTION Get_Biologicals

 for (i=1;i<=nyrs;i++)
  {
   weight_f(i) = wt_f;
   weight_m(i) = wt_m;
   maturity(i) = p_mature;
   
   if(M_type == 1)                                  // constant M
    {
     for (j=1;j<=nages;j++)
      { 
       M(i,j) = M_cnst; 
      }
    }
   if(M_type == 2)                                  // age-specific M
    {
     M(i) = M_age;
    }
  }

    weight_mat_prod_f = elem_prod(weight_f,maturity);

FUNCTION Get_Selectivity_Retention

// ###################################################################################################
// LOG-TRANSFORM FISHERY SELECTIVITY  PARAMETERS
// ###################################################################################################

  FG_a50_f = mfexp(log_FG_a50_f);                   // fem fixed gear logistic slx a50
  FG_a50_m = mfexp(log_FG_a50_m);                   // m fixed gear logistic slx a50
  trawl_a50_f = mfexp(log_trawl_a50_f);             // fem trawl gear logistic slx a50
  trawl_a50_m = mfexp(log_trawl_a50_m);             // m trawl gear logistic slx a50

  FG_delta_f = mfexp(log_FG_delta_f);               // fem fixed gear logistic slx delta
  FG_delta_m = mfexp(log_FG_delta_m);               // m fixed gear logistic slx delta
  trawl_delta_f = mfexp(log_trawl_delta_f);         // fem trawl gear logistic slx delta
  trawl_delta_m = mfexp(log_trawl_delta_m);         // m trawl gear logistic slx delta


// ###################################################################################################
// Calculate fishery selectivity and retention at age
// ###################################################################################################

  for (j=1;j<=nages;j++)
   {
    slx_FG_f(j) = 1/(1+mfexp(-FG_delta_f*(j-FG_a50_f)));    // logistic slx for FG fleet
    slx_FG_m(j) = 1/(1+mfexp(-FG_delta_m*(j-FG_a50_m)));

    slx_trawl_f(j) = (pow(j/trawl_a50_f,trawl_a50_f/(0.5*(sqrt(square(trawl_a50_f)+4*square(trawl_delta_f))-trawl_a50_f)))*mfexp((trawl_a50_f-j)/(0.5*(sqrt(square(trawl_a50_f)+4*square(trawl_delta_f))-trawl_a50_f))));      // gamma slx for trawl fleet
    slx_trawl_m(j) = (pow(j/trawl_a50_m,trawl_a50_m/(0.5*(sqrt(square(trawl_a50_m)+4*square(trawl_delta_m))-trawl_a50_m)))*mfexp((trawl_a50_m-j)/(0.5*(sqrt(square(trawl_a50_m)+4*square(trawl_delta_m))-trawl_a50_m))));

    if(retention_type == 1)                         // assume knife edge retention at the ret_age
     {
      if(j < ret_age_f)                             // no retention of fish below ret_age
       {
        ret_f(j) = 0;
       }
      if(j < ret_age_m)
       {
        ret_m(j) = 0;
       }
      if(j >= ret_age_f)                            // full retention of fish at or above ret_age
       {
        ret_f(j) = 1;
       }
      if(j >= ret_age_m)
       {
        ret_m(j) = 1;
       }
     }
    if(retention_type == 2)                         // assume logistic retention
     {
      ret_f(j) = 1/(1+mfexp(-ret_delta_f*(j-ret_a50_f)));    
      ret_m(j) = 1/(1+mfexp(-ret_delta_m*(j-ret_a50_m)));
     }
   } 

   slx_trawl_f=slx_trawl_f/max(slx_trawl_f);        //standardize gamma FXN to max of 1
   slx_trawl_m=slx_trawl_m/max(slx_trawl_m);        //standardize gamma FXN to max of 1
  
FUNCTION Compute_B40

// ###################################################################################################
// Calculate SPR
// ###################################################################################################

   //log transform estimated parameters
  mF50 = mfexp(log_mF50);
  mF40 = mfexp(log_mF40);
  mF35 = mfexp(log_mF35);
    
   // Scale F-spr rates to be on fully-selected values
  F50 = mF50*max(slx_FG_f);
  F40 = mF40*max(slx_FG_f);
  F35 = mF35*max(slx_FG_f);

   // initialize values
  sprpen = 0;
  SB0    = 0;
  SBF50  = 0;
  SBF40  = 0;
  SBF35  = 0;

   // calc SPR
  for (i=1;i<=4;i++)                                // i index is for the various SPR fractions (0, 0.5, 0.4, 0.35)
   {
    Nspr(i,1) = 1.;                                 // set recruits to 1 (standard for SPR calcs)
   }
    for (j=2;j<nages;j++)                           // calcs only account for female NAA, since only need SSB
     {
      Nspr(1,j) = Nspr(1,j-1)*mfexp(-1.*M(1,j-1));     
      Nspr(2,j) = Nspr(2,j-1)*mfexp(-1.*(M(1,j-1)+fract_trawl*mF50*slx_trawl_f(j-1)+((1-fract_trawl)*(mF50*slx_FG_f(j-1)*ret_f(j-1)+DMR_f*(1-ret_f(j-1))*mF50*slx_FG_f(j-1)))));
      Nspr(3,j) = Nspr(3,j-1)*mfexp(-1.*(M(1,j-1)+fract_trawl*mF40*slx_trawl_f(j-1)+((1-fract_trawl)*(mF40*slx_FG_f(j-1)*ret_f(j-1)+DMR_f*(1-ret_f(j-1))*mF40*slx_FG_f(j-1)))));
      Nspr(4,j) = Nspr(4,j-1)*mfexp(-1.*(M(1,j-1)+fract_trawl*mF35*slx_trawl_f(j-1)+((1-fract_trawl)*(mF35*slx_FG_f(j-1)*ret_f(j-1)+DMR_f*(1-ret_f(j-1))*mF35*slx_FG_f(j-1)))));
     }
     
   // plus group calcs
  Nspr(1,nages) = Nspr(1,nages-1)*mfexp(-1.*M(1,nages-1))/(1.-mfexp(-1.*M(1,nages)));
  Nspr(2,nages) = Nspr(2,nages-1)*mfexp(-1.*(M(1,nages-1)+fract_trawl*mF50*slx_trawl_f(nages-1)+((1-fract_trawl)*(mF50*slx_FG_f(nages-1)*ret_f(nages-1)+DMR_f*(1-ret_f(nages-1))*mF50*slx_FG_f(nages-1)))))/(1.-mfexp(-1.*(M(1,nages)+fract_trawl*mF50*slx_trawl_f(nages)+((1-fract_trawl)*(mF50*slx_FG_f(nages)*ret_f(nages)+DMR_f*(1-ret_f(nages))*mF50*slx_FG_f(nages))))));
  Nspr(3,nages) = Nspr(3,nages-1)*mfexp(-1.*(M(1,nages-1)+fract_trawl*mF40*slx_trawl_f(nages-1)+((1-fract_trawl)*(mF40*slx_FG_f(nages-1)*ret_f(nages-1)+DMR_f*(1-ret_f(nages-1))*mF40*slx_FG_f(nages-1)))))/(1.-mfexp(-1.*(M(1,nages)+fract_trawl*mF40*slx_trawl_f(nages)+((1-fract_trawl)*(mF40*slx_FG_f(nages)*ret_f(nages)+DMR_f*(1-ret_f(nages))*mF40*slx_FG_f(nages))))));
  Nspr(4,nages) = Nspr(4,nages-1)*mfexp(-1.*(M(1,nages-1)+fract_trawl*mF35*slx_trawl_f(nages-1)+((1-fract_trawl)*(mF35*slx_FG_f(nages-1)*ret_f(nages-1)+DMR_f*(1-ret_f(nages-1))*mF35*slx_FG_f(nages-1)))))/(1.-mfexp(-1.*(M(1,nages)+fract_trawl*mF35*slx_trawl_f(nages)+((1-fract_trawl)*(mF35*slx_FG_f(nages)*ret_f(nages)+DMR_f*(1-ret_f(nages))*mF35*slx_FG_f(nages))))));

  for (j=1;j<=nages;j++)                            // calculate associated SSB, accounting for mortality up until spawning occurs (spawn_fract)
   {
    SB0   += Nspr(1,j)*weight_mat_prod_f(1,j)*mfexp(-spawn_fract*M(1,j));
    SBF50 += Nspr(2,j)*weight_mat_prod_f(1,j)*mfexp(-spawn_fract*(M(1,j)+fract_trawl*mF50*slx_trawl_f(j)+((1-fract_trawl)*(mF50*slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*mF50*slx_FG_f(j)))));
    SBF40 += Nspr(3,j)*weight_mat_prod_f(1,j)*mfexp(-spawn_fract*(M(1,j)+fract_trawl*mF40*slx_trawl_f(j)+((1-fract_trawl)*(mF40*slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*mF40*slx_FG_f(j)))));
    SBF35 += Nspr(4,j)*weight_mat_prod_f(1,j)*mfexp(-spawn_fract*(M(1,j)+fract_trawl*mF35*slx_trawl_f(j)+((1-fract_trawl)*(mF35*slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*mF35*slx_FG_f(j)))));
   } 

   // calculate penalties for obj_fxn to ensure the estimated Fs achieve the desired fraction of SSB0
  sprpen += 100.*square(SBF50/SB0-0.5);
  sprpen += 100.*square(SBF40/SB0-0.4);
  sprpen += 100.*square(SBF35/SB0-0.35);

   // calculate the B40 reference point (i.e., the actual SSB at 40% B0; requires multiplying the SPR40% by the avearage recruitment)
  if(recruit_regime_shift == 1)                     // use the mean recruitment from the entire time series, as is typically done for NPFMC B40% HCR Projections 
   {
    B0 = SB0*(mean_rec_full*(1-prop_m));            // SSB100% recruitment is total across sexes so account for proportion female
    B40 = SBF40*(mean_rec_full*(1-prop_m));         // SSBB40% recruitment is total across sexes so account for proportion female
    B35 = SBF35*(mean_rec_full*(1-prop_m));         // SSB35% assocaited with FOFL, recruitment is total across sexes so account for proportion female
   }
  if(recruit_regime_shift == 2)                     // use the mean recruitment from the recent time series, assumes a recruitment regime shift in recent years and associated higher B40%
   {
    B0 = SB0*(mean_rec_recent*(1-prop_m));          // SSB100% recruitment is total across sexes so account for proportion female
    B40 = SBF40*(mean_rec_recent*(1-prop_m));       // recruitment is total across sexes so account for proportion female 
    B35 = SBF35*(mean_rec_recent*(1-prop_m));       // assocaited with FOFL, recruitment is total across sexes so account for proportion female 
   }

FUNCTION Compute_YPR
 if(do_full_YPR_switch == 1)                        // only do fully YPR calcs if ==1
  {
// ###################################################################################################
// Calculate Abundance per recruit
// ###################################################################################################

  F_YPR.initialize();
  
   // calc Numbers surviving
  for (i=1;i<=n_F_incr_ypr;i++)                     // loop through the full vector of Fs
   {
    if(i == 1)
     {
      F_YPR(i) = F_YPR_start;                       // set starting F
     }
    if(i > 1)
     {
      F_YPR(i) = F_YPR(i-1)+YPR_F_step;             // increase F by the F-step
     }
     
    N_YPR_f(i,1) = 1-prop_m;                        // set recruits to 1 (standard for SPR calcs)
    N_YPR_m(i,1) = prop_m;                          // set recruits to 1 (standard for SPR calcs)
     
   
    for (j=2;j<nages;j++)                           // calcs only account for female NAA, since only need SSB
     {
      N_YPR_f(i,j) = N_YPR_f(i,j-1)*mfexp(-1.*(M(1,j-1)+F_YPR(i)*(fract_trawl*slx_trawl_f(j-1)+(((1-fract_trawl)*slx_FG_f(j-1))*(ret_f(j-1)+DMR_f*(1-ret_f(j-1)))))));
      N_YPR_m(i,j) = N_YPR_m(i,j-1)*mfexp(-1.*(M(1,j-1)+F_YPR(i)*(fract_trawl*slx_trawl_m(j-1)+(((1-fract_trawl)*slx_FG_m(j-1))*(ret_m(j-1)+DMR_m*(1-ret_m(j-1)))))));
     }
     
     // plus group calcs
    N_YPR_f(i,nages) = N_YPR_f(i,nages-1)*mfexp(-1.*(M(1,nages-1)+F_YPR(i)*(fract_trawl*slx_trawl_f(nages-1)+(((1-fract_trawl)*slx_FG_f(nages-1))*(ret_f(nages-1)+DMR_f*(1-ret_f(nages-1)))))))/(1.-mfexp(-1.*(M(1,nages)+F_YPR(i)*(fract_trawl*slx_trawl_f(nages)+(((1-fract_trawl)*slx_FG_f(nages))*(ret_f(nages)+DMR_f*(1-ret_f(nages))))))));
    N_YPR_m(i,nages) = N_YPR_m(i,nages-1)*mfexp(-1.*(M(1,nages-1)+F_YPR(i)*(fract_trawl*slx_trawl_m(nages-1)+(((1-fract_trawl)*slx_FG_m(nages-1))*(ret_m(nages-1)+DMR_m*(1-ret_m(nages-1)))))))/(1.-mfexp(-1.*(M(1,nages)+F_YPR(i)*(fract_trawl*slx_trawl_m(nages)+(((1-fract_trawl)*slx_FG_m(nages))*(ret_m(nages)+DMR_m*(1-ret_m(nages))))))));

    // calculate SPR and YPR
   for (j=1;j<=nages;j++)                           
    {
     SPR(i,j) = N_YPR_f(i,j)*weight_mat_prod_f(1,j)*mfexp(-spawn_fract*(M(1,j)+F_YPR(i)*(fract_trawl*slx_trawl_f(j)+(((1-fract_trawl)*slx_FG_f(j))*(ret_f(j)+DMR_f*(1-ret_f(j)))))));         // calculate associated SSB, accounting for mortality up until spawning occurs (spawn_fract)       
     YPR_f(i,j) = N_YPR_f(i,j)*weight_f(1,j)*(1.-mfexp(-1.*(M(1,j)+F_YPR(i)*(fract_trawl*slx_trawl_f(j)+(((1-fract_trawl)*slx_FG_f(j))*(ret_f(j)+DMR_f*(1-ret_f(j))))))))*((F_YPR(i)*(fract_trawl*slx_trawl_f(j)+(1-fract_trawl)*slx_FG_f(j)*ret_f(j)))/(M(1,j)+F_YPR(i)*(fract_trawl*slx_trawl_f(j)+(((1-fract_trawl)*slx_FG_f(j))*(ret_f(j)+DMR_f*(1-ret_f(j)))))));     // yield == landings only, so only retained fish (no discards included in F removals)
     YPR_m(i,j) = N_YPR_m(i,j)*weight_m(1,j)*(1.-mfexp(-1.*(M(1,j)+F_YPR(i)*(fract_trawl*slx_trawl_m(j)+(((1-fract_trawl)*slx_FG_m(j))*(ret_m(j)+DMR_m*(1-ret_m(j))))))))*((F_YPR(i)*(fract_trawl*slx_trawl_m(j)+(1-fract_trawl)*slx_FG_m(j)*ret_m(j)))/(M(1,j)+F_YPR(i)*(fract_trawl*slx_trawl_m(j)+(((1-fract_trawl)*slx_FG_m(j))*(ret_m(j)+DMR_m*(1-ret_m(j)))))));
     YPR(i,j) = YPR_f(i,j)+YPR_m(i,j);
     RPR_curr(i,j) = YPR_f(i,j)*price_age_f(j)+YPR_m(i,j)*price_age_m(j);
     RPR_avg(i,j) = YPR_f(i,j)*price_age_f_avg(j)+YPR_m(i,j)*price_age_m_avg(j);
     RPR_max(i,j) = YPR_f(i,j)*max_price_f(j)+YPR_m(i,j)*max_price_m(j);
    }
   
   spr(i) = sum(SPR(i));                            // total SPR at given F
   ypr(i) = sum(YPR(i));                            // total YPR at given F
   rpr_curr(i) = sum(RPR_curr(i));                  // total RPR at given F, current price
   rpr_avg(i) = sum(RPR_avg(i));                    // total RPR at given F, average price
   rpr_max(i) = sum(RPR_max(i));                    // total RPR at given F, max price

   if(ypr(i) == max(ypr))                           // collect values associated with F max (max YPR)
    {
     ypr_Fmax = ypr(i);
     Fmax_ypr = F_YPR(i);
     spr_Fmax = spr(i);
     rpr_Fmax_curr = rpr_curr(i);
     rpr_Fmax_avg = rpr_avg(i);
     rpr_Fmax_max = rpr_max(i);
     loc_Fmax = i;
    }
   if(rpr_curr(i) == max(rpr_curr))                 // collect values associated with RPR_curr max
    {
     ypr_max_rpr_curr = ypr(i);
     F_max_rpr_curr = F_YPR(i);
     spr_max_rpr_curr = spr(i);
     rpr_max_curr = rpr_curr(i);
     loc_rpr_curr_max = i;
    }
   if(rpr_avg(i) == max(rpr_avg))                   // collect values associated with RPR_avg max
    {
     ypr_max_rpr_avg = ypr(i);
     F_max_rpr_avg = F_YPR(i);
     spr_max_rpr_avg = spr(i);
     rpr_max_avg = rpr_avg(i);
     loc_rpr_avg_max = i;
    }
   if(rpr_max(i) == max(rpr_max))                   // collect values associated with RPR_max max
    {
     ypr_max_rpr_max = ypr(i);
     F_max_rpr_max = F_YPR(i);
     spr_max_rpr_max = spr(i);
     rpr_max_max = rpr_max(i);
     loc_rpr_max_max = i;
    }
   if(((2*spr(i)/SB0) == 0.4) || (F_YPR(i) == F40) || ((i >1) && ((2*spr(i-1)/SB0) > 0.4) && ((2*spr(i)/SB0) <= 0.4)))   // collect values associated with SPR40% (*2 is because SB) calc based on R) of 1.0 these calcs use 0.5, won't be exact but probably close enough
    {
     ypr_F40 = ypr(i);
     F_F40 = F_YPR(i);
     spr_F40 = spr(i);
     rpr_F40_curr = rpr_curr(i);
     rpr_F40_avg = rpr_avg(i);
     rpr_F40_max = rpr_max(i);

     ypr_f40_age = YPR(i);
     spr_f40_age = SPR(i);
     rpr_f40_age_curr = RPR_curr(i);
     rpr_f40_age_avg = RPR_avg(i);
     rpr_f40_age_max = RPR_max(i);
    
     loc_F40 = i;
    }
   }
  }

FUNCTION Get_Population_Projection

  yrs(1) = styr;                                                         // vector of actual years

  if(harvest_fract_switch == 1)                                          // harvest full abc every year regardless of input harvest fraction
   {
    harvest_prop = 1;
   }
  if(harvest_fract_switch == 2)                                          // realized F is discounted for proportion ABC harvested (input), the landings in subsequent years associated with ABC will be based on the realized F in prior years (i.e., the NAA in the previous will be higher than under ABC, so ABC will be higher in current year than if had been harvesting ABC every previous year)
   {
    harvest_prop = harvest_prop_input;
   }

   // Abundance at start of first projection year for new recruits
  if(recruit_type == 1 && recruit_pattern == 1)                          // assume a low recruitment time series
   {
    N_proj_f(1,1) = RNG_vec_full(1)*(1-prop_m);
    N_proj_m(1,1) = RNG_vec_full(1)*(prop_m);
   }
  if(recruit_type == 1 && recruit_pattern == 2)                          // assume a hi recruitment time series
   {
    N_proj_f(1,1) = RNG_vec_recent(1)*(1-prop_m);
    N_proj_m(1,1) = RNG_vec_recent(1)*(prop_m);
   }
  if(recruit_type == 1 && recruit_pattern == 3)                          // assume a low-hi recruitment time series
   {
    N_proj_f(1,1) = RNG_vec_full(1)*(1-prop_m);
    N_proj_m(1,1) = RNG_vec_full(1)*(prop_m);
   }
  if(recruit_type == 1 && recruit_pattern == 4)                          // assume a hi-low recruitment time series
   {
    N_proj_f(1,1) = RNG_vec_recent(1)*(1-prop_m);
    N_proj_m(1,1) = RNG_vec_recent(1)*(prop_m);
   }
  if(recruit_type == 2)                                                  // input the recruitment time series directly
   {
    N_proj_f(1,1) = input_rec(1)*(1-prop_m);
    N_proj_m(1,1) = input_rec(1)*(prop_m);
   }
   
  recruits(1) = N_proj_f(1,1)+N_proj_m(1,1);                             // recruits in first year
  
   // Abundance at start of first projection year for subsequent ages
  for (j=1; j<nages-1;j++)
   {
    N_proj_f(1,j+1) = init_abund_f(j)*S_f_SAFE_term(j);                  // based on SAFE terminal year NAA (previous age) discounted for mortality during terminal year at that age
    N_proj_m(1,j+1) = init_abund_m(j)*S_m_SAFE_term(j);
   }

   // Abundance at start of first projection year for plus group
   N_proj_f(1,nages) = init_abund_f(nages-1)*S_f_SAFE_term(nages-1)+init_abund_f(nages)*S_f_SAFE_term(nages);
   N_proj_m(1,nages) = init_abund_m(nages-1)*S_m_SAFE_term(nages-1)+init_abund_m(nages)*S_m_SAFE_term(nages);

   // Total Abundance at start of first projection year summed across sexes
   N_proj_tot(1) = N_proj_f(1)+N_proj_m(1); 
   N(1) = sum(N_proj_tot(1));

   // full projection loop
  for (i=1;i<=nyrs;i++)
   {
     // SSB and biomass at start of year (ssb is later updated by mid-year calc after F_abc determined based on begin year SSB...this differs from SAFE/assessment version of HCR calcs)
    ssb_age(i) = elem_prod(N_proj_f(i),weight_mat_prod_f(i));
    ssb(i) = sum(ssb_age(i));
    bio(i) = sum(elem_prod(N_proj_f(i),weight_f(i)))+sum(elem_prod(N_proj_m(i),weight_m(i)));

     // Based on HCR and stock status (relative to SSB at start of year), calculate Fabc and Fofl for current year
    if(HCR_type == 1 || HCR_type == 2 || HCR_type == 3)                   // use B40% HCR, for HCR 2 will later modify realized F to scale in proportion to amount that landings in previous year > ABC cap
     {
      if(ssb(i)/B40 > 1.)                                                // use full F40 if above B40
       {
        FABC(i) = F40;
        FOFL(i) = F35;
       }
      else                                                               // sloping HCR if below B40
       {
        FABC(i) = F40*((ssb(i)/B40 - 0.05)/(1 - 0.05)); 
        FOFL(i) = F35*((ssb(i)/B40 - 0.05)/(1 - 0.05));
       }
     }

    F(i) = harvest_prop*FABC(i);                                         // realized fully selected F

     // Mortality Calcs
    for (j=1;j<=nages;j++)
     {
      FABC_age_f(i,j) = fract_trawl*FABC(i)*slx_trawl_f(j)+((1-fract_trawl)*(FABC(i)*slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*FABC(i)*slx_FG_f(j)));        // total dead fish F due to fishing at ABC
      FABC_age_m(i,j) = fract_trawl*FABC(i)*slx_trawl_m(j)+((1-fract_trawl)*(FABC(i)*slx_FG_m(j)*ret_f(j)+DMR_m*(1-ret_m(j))*FABC(i)*slx_FG_m(j)));
      FOFL_age_f(i,j) = fract_trawl*FOFL(i)*slx_trawl_f(j)+((1-fract_trawl)*(FOFL(i)*slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*FOFL(i)*slx_FG_f(j)));        // total dead fish F due to fishing at OFL
      FOFL_age_m(i,j) = fract_trawl*FOFL(i)*slx_trawl_m(j)+((1-fract_trawl)*(FOFL(i)*slx_FG_m(j)*ret_m(j)+DMR_m*(1-ret_m(j))*FOFL(i)*slx_FG_m(j)));
      F_age_f(i,j) = harvest_prop*FABC_age_f(i,j);                                                                                                         // actual F, discounted by fraction of ABC actual harvested
      F_age_m(i,j) = harvest_prop*FABC_age_m(i,j);                                                                                                         // actual F, discounted by fraction of ABC actual harvested

      Z_F_f(i,j) = F_age_f(i,j)+M(i,j);
      Z_F_m(i,j) = F_age_m(i,j)+M(i,j);
      Z_ABC_f(i,j) = FABC_age_f(i,j)+M(i,j);
      Z_ABC_m(i,j) = FABC_age_m(i,j)+M(i,j);
      Z_OFL_f(i,j) = FOFL_age_f(i,j)+M(i,j);
      Z_OFL_m(i,j) = FOFL_age_m(i,j)+M(i,j);
     }

     // Update SSB to account for spawning time in calc as in SPR calcs
    ssb_age(i) = elem_prod(elem_prod(N_proj_f(i),weight_mat_prod_f(i)),mfexp(-spawn_fract*Z_F_f(i)));
    ssb(i) = sum(ssb_age(i));

     // Catch-at-age and Discards-at-age 
    for (j=1;j<=nages;j++)
     { 
      CAA_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*(F_age_f(i,j)/Z_F_f(i,j));                                                            // Baranov the boss' catch eqn, all dead fish due to fishing at realized F
      CAA_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*(F_age_m(i,j)/Z_F_m(i,j));                                                            // Baranov the boss' catch eqn, all dead fish due to fishing at realized F
      CAA_ABC_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_ABC_f(i,j)))*(FABC_age_f(i,j)/Z_ABC_f(i,j));                                                 // Baranov the boss' catch eqn, all dead fish due to fishing at ABC
      CAA_ABC_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_ABC_m(i,j)))*(FABC_age_m(i,j)/Z_ABC_m(i,j));                                                 // Baranov the boss' catch eqn, all dead fish due to fishing at ABC
      CAA_OFL_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_OFL_f(i,j)))*(FOFL_age_f(i,j)/Z_OFL_f(i,j));                                                 // Baranov the boss' catch eqn, all dead fish due to fishing at OFL
      CAA_OFL_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_OFL_m(i,j)))*(FOFL_age_m(i,j)/Z_OFL_m(i,j));                                                 // Baranov the boss' catch eqn, all dead fish due to fishing at OFL

      CAA_landed_FG_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*(((1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_f(j)*ret_f(j))/Z_F_f(i,j));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
      CAA_landed_FG_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*(((1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_m(j)*ret_f(j))/Z_F_m(i,j));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
      CAA_ABC_landed_FG_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_ABC_f(i,j)))*(((1-fract_trawl)*FABC(i)*slx_FG_f(j)*ret_f(j))/Z_ABC_f(i,j));             // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at ABC
      CAA_ABC_landed_FG_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_ABC_m(i,j)))*(((1-fract_trawl)*FABC(i)*slx_FG_m(j)*ret_f(j))/Z_ABC_m(i,j));             // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at ABC
      CAA_OFL_landed_FG_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_OFL_f(i,j)))*(((1-fract_trawl)*FOFL(i)*slx_FG_f(j)*ret_f(j))/Z_OFL_f(i,j));             // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at OFL
      CAA_OFL_landed_FG_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_OFL_m(i,j)))*(((1-fract_trawl)*FOFL(i)*slx_FG_m(j)*ret_f(j))/Z_OFL_m(i,j));             // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at OFL

      CAA_landed_trwl_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*(((fract_trawl)*harvest_prop*FABC(i)*slx_trawl_f(j))/Z_F_f(i,j));              // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
      CAA_landed_trwl_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*(((fract_trawl)*harvest_prop*FABC(i)*slx_trawl_m(j))/Z_F_m(i,j));              // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
      CAA_ABC_landed_trwl_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_ABC_f(i,j)))*(((fract_trawl)*FABC(i)*slx_trawl_f(j))/Z_ABC_f(i,j));                   // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at ABC
      CAA_ABC_landed_trwl_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_ABC_m(i,j)))*(((fract_trawl)*FABC(i)*slx_trawl_m(j))/Z_ABC_m(i,j));                   // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at ABC
      CAA_OFL_landed_trwl_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_OFL_f(i,j)))*(((fract_trawl)*FOFL(i)*slx_trawl_f(j))/Z_OFL_f(i,j));                   // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at OFL
      CAA_OFL_landed_trwl_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_OFL_m(i,j)))*(((fract_trawl)*FOFL(i)*slx_trawl_m(j))/Z_OFL_m(i,j));                   // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at OFL

      DAA_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*(((1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_f(j)*(1-ret_f(j)))/Z_F_f(i,j));              // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at realized F
      DAA_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*(((1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_m(j)*(1-ret_f(j)))/Z_F_m(i,j));              // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at realized F
      DAA_ABC_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_ABC_f(i,j)))*(((1-fract_trawl)*FABC(i)*slx_FG_f(j)*(1-ret_f(j)))/Z_ABC_f(i,j));                   // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at ABC
      DAA_ABC_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_ABC_m(i,j)))*(((1-fract_trawl)*FABC(i)*slx_FG_m(j)*(1-ret_f(j)))/Z_ABC_m(i,j));                   // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at ABC
      DAA_OFL_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_OFL_f(i,j)))*(((1-fract_trawl)*FOFL(i)*slx_FG_f(j)*(1-ret_f(j)))/Z_OFL_f(i,j));                   // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at OFL
      DAA_OFL_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_OFL_m(i,j)))*(((1-fract_trawl)*FOFL(i)*slx_FG_m(j)*(1-ret_f(j)))/Z_OFL_m(i,j));                   // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at OFL

      DAA_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*(((1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_f(j)*DMR_f*(1-ret_f(j)))/Z_F_f(i,j));   // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at realized F
      DAA_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*(((1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_m(j)*DMR_m*(1-ret_f(j)))/Z_F_m(i,j));   // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at realized F
      DAA_ABC_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_ABC_f(i,j)))*(((1-fract_trawl)*FABC(i)*slx_FG_f(j)*DMR_f*(1-ret_f(j)))/Z_ABC_f(i,j));        // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at ABC
      DAA_ABC_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_ABC_m(i,j)))*(((1-fract_trawl)*FABC(i)*slx_FG_m(j)*DMR_m*(1-ret_f(j)))/Z_ABC_m(i,j));        // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at ABC
      DAA_OFL_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_OFL_f(i,j)))*(((1-fract_trawl)*FOFL(i)*slx_FG_f(j)*DMR_f*(1-ret_f(j)))/Z_OFL_f(i,j));        // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at OFL
      DAA_OFL_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_OFL_m(i,j)))*(((1-fract_trawl)*FOFL(i)*slx_FG_m(j)*DMR_m*(1-ret_f(j)))/Z_OFL_m(i,j));        // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at OFL
     }
     
    landings_FG(i) = sum(elem_prod(CAA_landed_FG_f(i),weight_f(i)))+sum(elem_prod(CAA_landed_FG_m(i),weight_m(i)));                                 // landings in weight from fixed gear fleet due to fishing at realized F
    landings_FG_ABC(i) = sum(elem_prod(CAA_ABC_landed_FG_f(i),weight_f(i)))+sum(elem_prod(CAA_ABC_landed_FG_m(i),weight_m(i)));                     // landings in weight from fixed gear fleet due to fishing at ABC
    landings_FG_OFL(i) = sum(elem_prod(CAA_OFL_landed_FG_f(i),weight_f(i)))+sum(elem_prod(CAA_OFL_landed_FG_m(i),weight_m(i)));                     // landings in weight from fixed gear fleet due to fishing at OFL

    landings_trawl(i) = sum(elem_prod(CAA_landed_trwl_f(i),weight_f(i)))+sum(elem_prod(CAA_landed_trwl_m(i),weight_m(i)));                          // landings in weight from trawl gear fleet due to fishing at realized F
    landings_trawl_ABC(i) = sum(elem_prod(CAA_ABC_landed_trwl_f(i),weight_f(i)))+sum(elem_prod(CAA_ABC_landed_trwl_m(i),weight_m(i)));              // landings in weight from trawl gear fleet due to fishing at ABC
    landings_trawl_OFL(i) = sum(elem_prod(CAA_OFL_landed_trwl_f(i),weight_f(i)))+sum(elem_prod(CAA_OFL_landed_trwl_m(i),weight_m(i)));              // landings in weight from trawl gear fleet due to fishing at OFL

    landings_tot(i) = landings_FG(i)+landings_trawl(i);                                                                                             // total landings in weight summed across fleets due to fishing at realized F
    landings_tot_ABC(i) = landings_FG_ABC(i)+landings_trawl_ABC(i);                                                                                 // total landings in weight summed across fleets due to fishing at ABC
    landings_tot_OFL(i) = landings_FG_OFL(i)+landings_trawl_OFL(i);                                                                                 // total landings in weight summed across fleets due to fishing at OFL

     if(HCR_type == 2 || HCR_type == 3)       // use capped HCR for landings, this is still UNDER CONSTRUCTION; goal is to scale FABC to produce a capped HCR to limit  landings; use Newton-Raphson to derive F that gives desired landings, not perfect but close enough in most years
      {
       fof_f.initialize();
       fof_m.initialize();
       landings_fof.initialize();
       fof_f_hi.initialize();
       fof_m_hi.initialize();
       landings_fof_hi.initialize();
       fof_f_lo.initialize();
       landings_fof_lo.initialize();
       fofF.initialize();
       fprimeF.initialize();
       
       if(HCR_type ==2 && ((landings_FG(i) < landings_cap) || (ssb(i)/B40 <= 1.)))   // if below cap or on slope of HCR
        {
         F_cap_adj_FG(i) = 1;                                                        // No adjustment to F
         F_cap_adj_tr(i) = 1;
        }

       if(HCR_type ==3 && ((landings_tot(i) < landings_cap) || (ssb(i)/B40 <= 1.)))  // if below cap or on slope of HCR
        {
         F_cap_adj_FG(i) = 1;                                                        // No adjustment to F
         F_cap_adj_tr(i) = 1;
        }
        
       if(HCR_type ==2 && landings_FG(i) >= landings_cap && (ssb(i)/B40 > 1.))       // if FG landings above the cap then reduce FG F in proportion to difference between cap and landings
        {
         F_new = Fnew_start;
         for(k=1;k<=NR_iterations;k++)                                               // do the Newton-Raphson iterative search for F that achieves landings cap in FG fishery only
          {
           delt=F_new*NR_dev;
           for(j=1;j<=nages;j++)
            {
             fof_f(j) = N_proj_f(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+(F_new*(1-fract_trawl)*(slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*slx_FG_f(j)))))))*((F_new*(1-fract_trawl)*harvest_prop*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+F_new*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
             fof_m(j) = N_proj_m(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_m(j)+(F_new*(1-fract_trawl)*(slx_FG_m(j)*ret_m(j)+DMR_m*(1-ret_m(j))*slx_FG_m(j)))))))*((F_new*(1-fract_trawl)*harvest_prop*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+F_new*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F

             fof_f_hi(j) = N_proj_f(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+((F_new+delt)*(1-fract_trawl)*(slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*slx_FG_f(j)))))))*(((F_new+delt)*(1-fract_trawl)*harvest_prop*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+(F_new+delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
             fof_m_hi(j) = N_proj_m(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_m(j)+((F_new+delt)*(1-fract_trawl)*(slx_FG_m(j)*ret_m(j)+DMR_m*(1-ret_m(j))*slx_FG_m(j)))))))*(((F_new+delt)*(1-fract_trawl)*harvest_prop*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+(F_new+delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F

             fof_f_lo(j) = N_proj_f(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+((F_new-delt)*(1-fract_trawl)*(slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*slx_FG_f(j)))))))*(((F_new-delt)*(1-fract_trawl)*harvest_prop*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+(F_new-delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
             fof_m_lo(j) = N_proj_m(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_m(j)+((F_new-delt)*(1-fract_trawl)*(slx_FG_m(j)*ret_m(j)+DMR_m*(1-ret_m(j))*slx_FG_m(j)))))))*(((F_new-delt)*(1-fract_trawl)*harvest_prop*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(fract_trawl*FABC(i)*slx_trawl_f(j)+(F_new-delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
            }
            
           landings_fof = sum(elem_prod(fof_f,weight_f(i)))+sum(elem_prod(fof_m,weight_m(i)));
           landings_fof_hi = sum(elem_prod(fof_f_hi,weight_f(i)))+sum(elem_prod(fof_m_hi,weight_m(i)));
           landings_fof_lo = sum(elem_prod(fof_f_lo,weight_f(i)))+sum(elem_prod(fof_m_lo,weight_m(i)));

           fofF = landings_fof-landings_cap;
           fprimeF = (landings_fof_hi-landings_fof_lo)/(2.0*delt);
           F_new = F_new-(fofF/fprimeF);
           if(F_new < 0) F_new = 0.5*(F_new+(fofF/fprimeF));
           if(F_new > max_Fnew) F_new = max_Fnew;
          }

         F_cap_adj_FG(i) = F_new/FABC(i);                                            // calculated proprotional reduction in F based on landings relative to landings cap
         F_cap_adj_tr(i) = 1;                                                        // calculated proprotional reduction in F based on landings relative to landings cap
        }

       if(HCR_type == 3 && landings_tot(i) >= landings_cap && (ssb(i)/B40 > 1.))     // if total landings above the cap then reduce total F in proportion to difference between cap and landings
        {
         F_new = Fnew_start;
         for(k=1;k<=NR_iterations;k++)                                               // do the Newton-Raphson iterative search for F that achieves landings cap
          {
           delt=F_new*NR_dev;
           for(j=1;j<=nages;j++)
            {
             fof_f(j) = N_proj_f(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(F_new*fract_trawl*slx_trawl_f(j)+(F_new*(1-fract_trawl)*(slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*slx_FG_f(j)))))))*(harvest_prop*(F_new*fract_trawl*slx_trawl_f(j)+F_new*(1-fract_trawl)*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(F_new*fract_trawl*slx_trawl_f(j)+F_new*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
             fof_m(j) = N_proj_m(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*(F_new*fract_trawl*slx_trawl_m(j)+(F_new*(1-fract_trawl)*(slx_FG_m(j)*ret_m(j)+DMR_m*(1-ret_m(j))*slx_FG_m(j)))))))*(harvest_prop*(F_new*fract_trawl*slx_trawl_f(j)+F_new*(1-fract_trawl)*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*(F_new*fract_trawl*slx_trawl_f(j)+F_new*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F

             fof_f_hi(j) = N_proj_f(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*((F_new+delt)*fract_trawl*slx_trawl_f(j)+((F_new+delt)*(1-fract_trawl)*(slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*slx_FG_f(j)))))))*(harvest_prop*((F_new+delt)*fract_trawl*slx_trawl_f(j)+(F_new+delt)*(1-fract_trawl)*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*((F_new+delt)*fract_trawl*slx_trawl_f(j)+(F_new+delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
             fof_m_hi(j) = N_proj_m(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*((F_new+delt)*fract_trawl*slx_trawl_m(j)+((F_new+delt)*(1-fract_trawl)*(slx_FG_m(j)*ret_m(j)+DMR_m*(1-ret_m(j))*slx_FG_m(j)))))))*(harvest_prop*((F_new+delt)*fract_trawl*slx_trawl_f(j)+(F_new+delt)*(1-fract_trawl)*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*((F_new+delt)*fract_trawl*slx_trawl_f(j)+(F_new+delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F

             fof_f_lo(j) = N_proj_f(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*((F_new-delt)*fract_trawl*slx_trawl_f(j)+((F_new-delt)*(1-fract_trawl)*(slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*slx_FG_f(j)))))))*(harvest_prop*((F_new-delt)*fract_trawl*slx_trawl_f(j)+(F_new-delt)*(1-fract_trawl)*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*((F_new-delt)*fract_trawl*slx_trawl_f(j)+(F_new-delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
             fof_m_lo(j) = N_proj_m(i,j)*(1.-mfexp(-(M(i,j)+harvest_prop*((F_new-delt)*fract_trawl*slx_trawl_m(j)+((F_new-delt)*(1-fract_trawl)*(slx_FG_m(j)*ret_m(j)+DMR_m*(1-ret_m(j))*slx_FG_m(j)))))))*(harvest_prop*((F_new-delt)*fract_trawl*slx_trawl_f(j)+(F_new-delt)*(1-fract_trawl)*slx_FG_f(j)*ret_f(j))/(M(i,j)+harvest_prop*((F_new-delt)*fract_trawl*slx_trawl_f(j)+(F_new-delt)*(1-fract_trawl)*((slx_FG_f(j)*ret_f(j))+(DMR_f*(1-ret_f(j))*slx_FG_f(j))))));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
            }
            
           landings_fof = sum(elem_prod(fof_f,weight_f(i)))+sum(elem_prod(fof_m,weight_m(i)));
           landings_fof_hi = sum(elem_prod(fof_f_hi,weight_f(i)))+sum(elem_prod(fof_m_hi,weight_m(i)));
           landings_fof_lo = sum(elem_prod(fof_f_lo,weight_f(i)))+sum(elem_prod(fof_m_lo,weight_m(i)));

           fofF = landings_fof-landings_cap;
           fprimeF = (landings_fof_hi-landings_fof_lo)/(2.0*delt);
           F_new = F_new-(fofF/fprimeF);
           if(F_new < 0) F_new = 0.5*(F_new+(fofF/fprimeF));
           if(F_new > max_Fnew) F_new = max_Fnew;
          }

         F_cap_adj_FG(i) = F_new/FABC(i);                                            // calculated proprotional reduction in F based on landings relative to landings cap
         F_cap_adj_tr(i) = F_new/FABC(i);                                            // calculated proprotional reduction in F based on landings relative to landings cap
        }
        
       for (j=1;j<=nages;j++)
        {
          // adjust mortality rates to account for new lower F
         F_age_f(i,j) = harvest_prop*(F_cap_adj_tr(i)*fract_trawl*FABC(i)*slx_trawl_f(j)+(F_cap_adj_FG(i)*(1-fract_trawl)*(FABC(i)*slx_FG_f(j)*ret_f(j)+DMR_f*(1-ret_f(j))*FABC(i)*slx_FG_f(j))));        // adjust F-at-age to reduce FG fleet F to try and get down to landings cap; this is imperfectly implemented but gets in ball park
         F_age_m(i,j) = harvest_prop*(F_cap_adj_tr(i)*fract_trawl*FABC(i)*slx_trawl_m(j)+(F_cap_adj_FG(i)*(1-fract_trawl)*(FABC(i)*slx_FG_m(j)*ret_f(j)+DMR_m*(1-ret_m(j))*FABC(i)*slx_FG_m(j))));
         F(i) = harvest_prop*(F_cap_adj_tr(i)*fract_trawl*FABC(i)+F_cap_adj_FG(i)*(1-fract_trawl)*FABC(i));
           
         Z_F_f(i,j) = F_age_f(i,j)+M(i,j);
         Z_F_m(i,j) = F_age_m(i,j)+M(i,j);

          // recalculate removals and catch due to new FG F
         CAA_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*(F_age_f(i,j)/Z_F_f(i,j));                                                                            // Baranov the boss' catch eqn, all dead fish due to fishing at realized F
         CAA_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*(F_age_m(i,j)/Z_F_m(i,j));                                                                            // Baranov the boss' catch eqn, all dead fish due to fishing at realized F

         CAA_landed_FG_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*((F_cap_adj_FG(i)*(1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_f(j)*ret_f(j))/Z_F_f(i,j));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
         CAA_landed_FG_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*((F_cap_adj_FG(i)*(1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_m(j)*ret_f(j))/Z_F_m(i,j));        // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F

         CAA_landed_trwl_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*((F_cap_adj_tr(i)*(fract_trawl)*harvest_prop*FABC(i)*slx_trawl_f(j))/Z_F_f(i,j));              // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F
         CAA_landed_trwl_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*((F_cap_adj_tr(i)*(fract_trawl)*harvest_prop*FABC(i)*slx_trawl_m(j))/Z_F_m(i,j));              // Baranov the boss' catch eqn, all landed fish due to fixed gear fishing at realized F

         DAA_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*((F_cap_adj_FG(i)*(1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_f(j)*(1-ret_f(j)))/Z_F_f(i,j));              // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at realized F
         DAA_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*((F_cap_adj_FG(i)*(1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_m(j)*(1-ret_f(j)))/Z_F_m(i,j));              // Baranov the boss' catch eqn, all discarded fish due to fixed gear fishing at realized F

         DAA_dead_f(i,j) = N_proj_f(i,j)*(1.-mfexp(-Z_F_f(i,j)))*((F_cap_adj_FG(i)*(1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_f(j)*DMR_f*(1-ret_f(j)))/Z_F_f(i,j));   // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at realized F
         DAA_dead_m(i,j) = N_proj_m(i,j)*(1.-mfexp(-Z_F_m(i,j)))*((F_cap_adj_FG(i)*(1-fract_trawl)*harvest_prop*FABC(i)*slx_FG_m(j)*DMR_m*(1-ret_f(j)))/Z_F_m(i,j));   // Baranov the boss' catch eqn, all dead discarded fish due to fixed gear fishing at realized F
        }

       landings_FG(i) = sum(elem_prod(CAA_landed_FG_f(i),weight_f(i)))+sum(elem_prod(CAA_landed_FG_m(i),weight_m(i)));                                                 // landings in weight from fixed gear fleet due to fishing at realized F
       landings_trawl(i) = sum(elem_prod(CAA_landed_trwl_f(i),weight_f(i)))+sum(elem_prod(CAA_landed_trwl_m(i),weight_m(i)));                                          // landings in weight from trawl gear fleet due to fishing at realized F
       landings_tot(i) = landings_FG(i)+landings_trawl(i);                                                                                                             // total landings in weight summed across fleets due to fishing at realized F                                                                               // total landings in weight summed across fleets due to fishing at OFL
      }
      
     // Total catch and discards 
    dead_removals(i) = sum(elem_prod(CAA_dead_f(i),weight_f(i)))+sum(elem_prod(CAA_dead_m(i),weight_m(i)));                                                            // dead removals (total dead fish) in weight due to fishing at realized F
    dead_removals_ABC(i) = sum(elem_prod(CAA_ABC_dead_f(i),weight_f(i)))+sum(elem_prod(CAA_ABC_dead_m(i),weight_m(i)));                                                // dead removals (total dead fish) in weight due to fishing at ABC
    dead_removals_OFL(i) = sum(elem_prod(CAA_OFL_dead_f(i),weight_f(i)))+sum(elem_prod(CAA_OFL_dead_m(i),weight_m(i)));                                                // dead removals (total dead fish) in weight due to fishing at OFL

    disc(i) = sum(elem_prod(DAA_f(i),weight_f(i)))+sum(elem_prod(DAA_m(i),weight_m(i)));                                                                               // total discards from fixed gear in weight due to fishing at realized F
    disc_ABC(i) = sum(elem_prod(DAA_ABC_f(i),weight_f(i)))+sum(elem_prod(DAA_ABC_m(i),weight_m(i)));                                                                   // total discards from fixed gear in weight due to fishing at ABC
    disc_OFL(i) = sum(elem_prod(DAA_OFL_f(i),weight_f(i)))+sum(elem_prod(DAA_OFL_m(i),weight_m(i)));                                                                   // total discards from fixed gear in weight due to fishing at OFL

    dead_disc(i) = sum(elem_prod(DAA_dead_f(i),weight_f(i)))+sum(elem_prod(DAA_dead_m(i),weight_m(i)));                                                                // dead discards from fixed gear in weight due to fishing at realized F
    dead_disc_ABC(i) = sum(elem_prod(DAA_ABC_dead_f(i),weight_f(i)))+sum(elem_prod(DAA_ABC_dead_m(i),weight_m(i)));                                                    // dead discards from fixed gear in weight due to fishing at ABC
    dead_disc_OFL(i) = sum(elem_prod(DAA_OFL_dead_f(i),weight_f(i)))+sum(elem_prod(DAA_OFL_dead_m(i),weight_m(i)));                                                    // dead discards from fixed gear in weight due to fishing at OFL

     // Landed value from fixed gear fleet based on price grade info
    if(price_type == 1)                             // use input price grade info from most recent year
     {
      revenue_age(i) = elem_prod(elem_prod(CAA_landed_FG_f(i),weight_f(i)),price_age_f)+elem_prod(elem_prod(CAA_landed_FG_m(i),weight_m(i)),price_age_m);                      // gross revenue-at-age in fixed gear fleet due to fishing at realized F
      revenue_age_ABC(i) = elem_prod(elem_prod(CAA_ABC_landed_FG_f(i),weight_f(i)),price_age_f)+elem_prod(elem_prod(CAA_ABC_landed_FG_m(i),weight_m(i)),price_age_m);          // gross revenue-at-age in fixed gear fleet due to fishing at ABC
      revenue_age_OFL(i) = elem_prod(elem_prod(CAA_OFL_landed_FG_f(i),weight_f(i)),price_age_f)+elem_prod(elem_prod(CAA_OFL_landed_FG_m(i),weight_m(i)),price_age_m);          // gross revenue-at-age in fixed gear fleet due to fishing at OFL

      revenue(i) = sum(revenue_age(i));                                                                                                                                        // gross revenue in fixed gear fleet due to fishing at realized F
      revenue_ABC(i) = sum(revenue_age_ABC(i));                                                                                                                                // gross revenue in fixed gear fleet due to fishing at ABC
      revenue_OFL(i) = sum(revenue_age_OFL(i));                                                                                                                                // gross revenue in fixed gear fleet due to fishing at OFL
     }
    if(price_type == 2)                             // use average price grade info
     {
      revenue_age(i) = elem_prod(elem_prod(CAA_landed_FG_f(i),weight_f(i)),price_age_f_avg)+elem_prod(elem_prod(CAA_landed_FG_m(i),weight_m(i)),price_age_m_avg);              // gross revenue-at-age in fixed gear fleet due to fishing at realized F
      revenue_age_ABC(i) = elem_prod(elem_prod(CAA_ABC_landed_FG_f(i),weight_f(i)),price_age_f_avg)+elem_prod(elem_prod(CAA_ABC_landed_FG_m(i),weight_m(i)),price_age_m_avg);  // gross revenue-at-age in fixed gear fleet due to fishing at ABC
      revenue_age_OFL(i) = elem_prod(elem_prod(CAA_OFL_landed_FG_f(i),weight_f(i)),price_age_f_avg)+elem_prod(elem_prod(CAA_OFL_landed_FG_m(i),weight_m(i)),price_age_m_avg);  // gross revenue-at-age in fixed gear fleet due to fishing at OFL

      revenue(i) = sum(revenue_age(i));                                                                                                                                        // gross revenue in fixed gear fleet due to fishing at realized F
      revenue_ABC(i) = sum(revenue_age_ABC(i));                                                                                                                                // gross revenue in fixed gear fleet due to fishing at ABC
      revenue_OFL(i) = sum(revenue_age_OFL(i));                                                                                                                                // gross revenue in fixed gear fleet due to fishing at OFL
     }
    if(price_type == 3)                             // use linear scaling of price based on ratio of catch to landings at min price and difference in price between min and max (e.g 2017) (i.e., if landings < landings 2023, increase price in proportion to relative difference in landings)                                                                                                     // scale input price grades by price_inc to increase price as ABC decreases relative to 2023 ABC
     {
      for (j=1;j<=nages;j++)
       {
        if(landings_tot(i) >= landings_SAFE)        // if landings are greater than terminal year of SAFE landings, then maintain price at input price (low price)
         {
          price_age_scaled_f(i,j) = price_age_f(j);                                                  
          price_age_scaled_m(i,j) = price_age_m(j);                                                                                 
         }
        if((landings_tot(i) < landings_SAFE) && (landings_tot(i) > land_price_max))      // increase price inversely to relative landings in terminal year of SAFE (increase price if landings < 2023 landings, and vice versa)
         {
          price_age_scaled_f(i,j) = price_age_f(j)+((landings_SAFE-landings_tot(i))/(landings_SAFE-land_price_max))*(max_price_f(j)-price_age_f(j));     
          price_age_scaled_m(i,j) = price_age_m(j)+((landings_SAFE-landings_tot(i))/(landings_SAFE-land_price_max))*(max_price_m(j)-price_age_m(j));
         }       
        if(price_age_scaled_f(i,j) < price_age_f(j))                                     // if price goes below min_price set to min_price
         {
          price_age_scaled_f(i,j) = price_age_f(j);
         }
        if(price_age_scaled_m(i,j) < price_age_m(j))                                     // if price goes below min_price set to min_price
         {
          price_age_scaled_m(i,j) = price_age_m(j);
         }
        if(price_age_scaled_f(i,j) > max_price_f(j))                                     // if price goes above max_price set to max_price
         {
          price_age_scaled_f(i,j) = max_price_f(j);
         }
        if(price_age_scaled_m(i,j) > max_price_m(j))                                     // if price goes above max_price set to max_price
         {
          price_age_scaled_m(i,j) = max_price_m(j);
         }
       }

      revenue_age(i) = elem_prod(elem_prod(CAA_landed_FG_f(i),weight_f(i)),price_age_scaled_f(i))+elem_prod(elem_prod(CAA_landed_FG_m(i),weight_m(i)),price_age_scaled_m(i));                    // gross revenue-at-age in fixed gear fleet due to fishing at realized F
      revenue_age_ABC(i) = elem_prod(elem_prod(CAA_ABC_landed_FG_f(i),weight_f(i)),price_age_scaled_f(i))+elem_prod(elem_prod(CAA_ABC_landed_FG_m(i),weight_m(i)),price_age_scaled_m(i));        // gross revenue-at-age in fixed gear fleet due to fishing at ABC
      revenue_age_OFL(i) = elem_prod(elem_prod(CAA_OFL_landed_FG_f(i),weight_f(i)),price_age_scaled_f(i))+elem_prod(elem_prod(CAA_OFL_landed_FG_m(i),weight_m(i)),price_age_scaled_m(i));        // gross revenue-at-age in fixed gear fleet due to fishing at OFL

      revenue(i) = sum(revenue_age(i));                                                                                                                                                          // gross revenue in fixed gear fleet due to fishing at realized F
      revenue_ABC(i) = sum(revenue_age_ABC(i));                                                                                                                                                  // gross revenue in fixed gear fleet due to fishing at ABC
      revenue_OFL(i) = sum(revenue_age_OFL(i));                                                                                                                                                  // gross revenue in fixed gear fleet due to fishing at OFL
     }
     
     // Next year's abundance
    if(i < nyrs)
     {
       yrs(i+1) = yrs(i)+1;                                              // vector of actual years
       // Abundance at start of next year for new recruits
      if(recruit_type == 1 && recruit_pattern == 1)                      // assume a low recruitment time series
       {
        N_proj_f(i+1,1) = RNG_vec_full(i+1)*(1-prop_m);
        N_proj_m(i+1,1) = RNG_vec_full(i+1)*(prop_m);
       }
      if(recruit_type == 1 && recruit_pattern == 2)                      // assume a hi recruitment time series
       {
        N_proj_f(i+1,1) = RNG_vec_recent(i+1)*(1-prop_m);
        N_proj_m(i+1,1) = RNG_vec_recent(i+1)*(prop_m);
       }
      if(recruit_type == 1 && recruit_pattern == 3)                      // assume a low-hi recruitment time series
       {
        if((i+1) < nyrs_half)                                            // if in first half of time series use full recruitment samples   
         {
          N_proj_f(i+1,1) = RNG_vec_full(i+1)*(1-prop_m);
          N_proj_m(i+1,1) = RNG_vec_full(i+1)*(prop_m);
         }
        if((i+1) >= nyrs_half)                                           // if in second half of time series use recent recruitment samples   
         {
          N_proj_f(i+1,1) = RNG_vec_recent(i+1)*(1-prop_m);
          N_proj_m(i+1,1) = RNG_vec_recent(i+1)*(prop_m);
         }
       }
      if(recruit_type == 1 && recruit_pattern == 4)                      // assume a hi-low recruitment time series
       {
        if((i+1) < nyrs_half)                                            // if in first half of time series use recent recruitment samples   
         {
          N_proj_f(i+1,1) = RNG_vec_recent(i+1)*(1-prop_m);
          N_proj_m(i+1,1) = RNG_vec_recent(i+1)*(prop_m);
         }
        if((i+1) >= nyrs_half)                                           // if in second half of time series use full recruitment samples   
         {
          N_proj_f(i+1,1) = RNG_vec_full(i+1)*(1-prop_m);
          N_proj_m(i+1,1) = RNG_vec_full(i+1)*(prop_m);
         }
       }
      if(recruit_type == 2)                                              // input the recruitment time series directly
       {
        N_proj_f(i+1,1) = input_rec(i+1)*(1-prop_m);
        N_proj_m(i+1,1) = input_rec(i+1)*(prop_m);
       }

      recruits(i+1) = N_proj_f(i+1,1)+N_proj_m(i+1,1);                   // recruits 

       // Abundance for subsequent ages
      for (j=1; j<(nages-1);j++)
       {
        N_proj_f(i+1,j+1) = N_proj_f(i,j)*mfexp(-F_age_f(i,j)-M(i,j));
        N_proj_m(i+1,j+1) = N_proj_m(i,j)*mfexp(-F_age_m(i,j)-M(i,j));
       }
       
       // Abundance for plus group      
      N_proj_f(i+1,nages) = N_proj_f(i,nages-1)*mfexp(-F_age_f(i,nages-1)-M(i,nages-1))+N_proj_f(i,nages)*mfexp(-F_age_f(i,nages)-M(i,nages));
      N_proj_m(i+1,nages) = N_proj_m(i,nages-1)*mfexp(-F_age_m(i,nages-1)-M(i,nages-1))+N_proj_m(i,nages)*mfexp(-F_age_m(i,nages)-M(i,nages));

       // Total Abundance summed across sexes
      N_proj_tot(i+1) = N_proj_f(i+1)+N_proj_m(i+1);
      N(i+1) = sum(N_proj_tot(i+1));
     }              
   }   

FUNCTION Evaluate_Objective_Function

  obj_fun.initialize();

  obj_fun = sprpen;                                 // To solve for the F40 etc.
  
REPORT_SECTION

   // Biomass reference points
  report<<"$b0"<<endl;
  report<<B0<<endl;
  report<<"$b40"<<endl;
  report<<B40<<endl;
  report<<"$b35"<<endl;
  report<<B35<<endl;
  report<<"$f40"<<endl;
  report<<F40<<endl;
  report<<"$f35"<<endl;
  report<<F35<<endl;

   // F reference points
  report<<"$f_abc"<<endl;
  report<<FABC<<endl;
  report<<"$f_ofl"<<endl;
  report<<FOFL<<endl;

   // ABC, OFL reference points, and realized dead removals
  report<<"$dead_catch"<<endl;
  report<<dead_removals<<endl;
  report<<"$abc"<<endl;
  report<<dead_removals_ABC<<endl;
  report<<"$ofl"<<endl;
  report<<dead_removals_OFL<<endl;

   // Realized population Trajectories (depending on whether fished at realized F or ABC/OFL)
  report<<"$bio"<<endl;
  report<<bio<<endl;
  report<<"$ssb"<<endl;
  report<<ssb<<endl;
  report<<"$recr"<<endl;
  report<<recruits<<endl;
  report<<"$tot_n"<<endl;
  report<<N<<endl;
  report<<"$f"<<endl;
  report<<F<<endl;
  report<<"$f_cap_adj_fg"<<endl;
  report<<F_cap_adj_FG<<endl;
  report<<"$f_cap_adj_tr"<<endl;
  report<<F_cap_adj_tr<<endl;

   // Realized landings, discards, etc
  report<<"$land_tot"<<endl;
  report<<landings_tot<<endl;
  report<<"$land_fg"<<endl;
  report<<landings_FG<<endl;
  report<<"$land_tr"<<endl;
  report<<landings_trawl<<endl;
  report<<"$disc"<<endl;
  report<<disc<<endl;
  report<<"$disc_dead"<<endl;
  report<<dead_disc<<endl;

   // ABC landings, discards, etc
  report<<"$abc_land_fg"<<endl;
  report<<landings_FG_ABC<<endl;
  report<<"$abc_land_tr"<<endl;
  report<<landings_trawl_ABC<<endl;
  report<<"$abc_disc"<<endl;
  report<<disc_ABC<<endl;
  report<<"$abc_disc_dead"<<endl;
  report<<dead_disc_ABC<<endl;

   // OFL landings, discards, etc
  report<<"$ofl_land_fg"<<endl;
  report<<landings_FG_OFL<<endl;
  report<<"$ofl_land_tr"<<endl;
  report<<landings_trawl_OFL<<endl;
  report<<"$ofl_disc"<<endl;
  report<<disc_OFL<<endl;
  report<<"$ofl_disc_dead"<<endl;
  report<<dead_disc_OFL<<endl;

   // gross revenue
  report<<"$rev"<<endl;
  report<<revenue<<endl;
  report<<"$rev_abc"<<endl;
  report<<revenue_ABC<<endl;
  report<<"$rev_ofl"<<endl;
  report<<revenue_OFL<<endl;

   // Selectivity and retention
  report<<"$dmr_f"<<endl;
  report<<DMR_f<<endl;
  report<<"$dmr_f"<<endl;
  report<<DMR_f<<endl;
  report<<"$slx_fg_f"<<endl;
  report<<slx_FG_f<<endl;
  report<<"$slx_fg_m"<<endl;
  report<<slx_FG_m<<endl;
  report<<"$slx_tr_f"<<endl;
  report<<slx_trawl_f<<endl;
  report<<"$slx_tr_m"<<endl;
  report<<slx_trawl_m<<endl;
  report<<"$ret_fg_f"<<endl;
  report<<ret_f<<endl;
  report<<"$ret_fg_m"<<endl;
  report<<ret_m<<endl;

   // Input switches defining scenario
  report<<"$harvest_fract_switch"<<endl;
  report<<harvest_fract_switch<<endl;
  report<<"$retention_type"<<endl;
  report<<retention_type<<endl;
  report<<"$recruit_type"<<endl;
  report<<recruit_type<<endl;
  report<<"$recruit_pattern"<<endl;
  report<<recruit_pattern<<endl;
  report<<"$recruit_regime_shift"<<endl;
  report<<recruit_regime_shift<<endl;
  report<<"$M_type"<<endl;
  report<<M_type<<endl;
  report<<"$HCR_type"<<endl;
  report<<HCR_type<<endl;
  report<<"$price_type"<<endl;
  report<<price_type<<endl;

   // Input settings
  report<<"$styr"<<endl;
  report<<styr<<endl;
  report<<"$endyr"<<endl;
  report<<endyr<<endl;
  report<<"$recage"<<endl;
  report<<recage<<endl;
  report<<"$nages"<<endl;
  report<<nages<<endl;
  report<<"$nyrs"<<endl;
  report<<nyrs<<endl;
  report<<"$yrs"<<endl;
  report<<yrs<<endl;
  report<<"$styr"<<endl;
  report<<styr<<endl;

   // Biological Inputs
  report<<"$mat"<<endl;
  report<<p_mature<<endl;
  report<<"$wt_m"<<endl;
  report<<wt_m<<endl;
  report<<"$wt_f"<<endl;
  report<<wt_f<<endl;
  report<<"$prop_m"<<endl;
  report<<prop_m<<endl;
  report<<"$m"<<endl;
  report<<M(1)<<endl;

   // Other Inputs from SAFE
  report<<"$fract_trawl"<<endl;
  report<<fract_trawl<<endl;
  report<<"$abc_curr"<<endl;
  report<<ABC_SAFE<<endl;
  report<<"$land_cap"<<endl;
  report<<landings_cap<<endl;
  report<<"$land_curr"<<endl;
  report<<landings_SAFE<<endl;
  report<<"$harv_prop"<<endl;
  report<<harvest_prop_input<<endl;
  report<<"$price_age_f"<<endl;
  report<<price_age_f<<endl;
  report<<"$price_age_m"<<endl;
  report<<price_age_m<<endl;
  report<<"$price_age_avg_f"<<endl;
  report<<price_age_f_avg<<endl;
  report<<"$price_age_avg_m"<<endl;
  report<<price_age_m_avg<<endl;
  report<<"$price_age_new_f"<<endl;
  report<<price_age_scaled_f<<endl;
  report<<"$price_age_new_m"<<endl;
  report<<price_age_scaled_m<<endl;
  report<<"$max_price_age_f"<<endl;
  report<<max_price_f<<endl;
  report<<"$max_price_age_m"<<endl;
  report<<max_price_m<<endl;
  report<<"$land_price_max"<<endl;
  report<<land_price_max<<endl;

   // Abundance-at-age
  report<<"$naa_f"<<endl;
  report<<N_proj_f<<endl;
  report<<"$naa_m"<<endl;
  report<<N_proj_m<<endl;
  report<<"$naa_tot"<<endl;
  report<<N<<endl;
  report<<"$ssb_age"<<endl;
  report<<ssb_age<<endl;

   // Realized F-at-age, FABC, and FOFL
  report<<"$faa_f"<<endl;
  report<<F_age_f<<endl;
  report<<"$faa_m"<<endl;
  report<<F_age_m<<endl;
  report<<"$faa_abc_f"<<endl;
  report<<FABC_age_f<<endl;
  report<<"$faa_abc_m"<<endl;
  report<<FABC_age_m<<endl;
  report<<"$faa_ofl_f"<<endl;
  report<<FOFL_age_f<<endl;
  report<<"$faa_ofl_m"<<endl;
  report<<FOFL_age_m<<endl;

   // Realized Z-at-age, ZABC, and ZOFL
  report<<"$zaa_f"<<endl;
  report<<Z_F_f<<endl;
  report<<"$zaa_m"<<endl;
  report<<Z_F_m<<endl;
  report<<"$zaa_abc_f"<<endl;
  report<<Z_ABC_f<<endl;
  report<<"$zaa_abc_m"<<endl;
  report<<Z_ABC_m<<endl;
  report<<"$zaa_ofl_f"<<endl;
  report<<Z_OFL_f<<endl;
  report<<"$zaa_ofl_m"<<endl;
  report<<Z_OFL_m<<endl;

   // Realized catch-at-age, discards-at-age, etc.
  report<<"$caa_dead_f"<<endl;
  report<<CAA_dead_f<<endl;
  report<<"$caa_dead_m"<<endl;
  report<<CAA_dead_m<<endl;
  report<<"$laa_fg_f"<<endl;
  report<<CAA_landed_FG_f<<endl;
  report<<"laa_fg_m"<<endl;
  report<<CAA_landed_FG_m<<endl;
  report<<"$laa_tr_f"<<endl;
  report<<CAA_landed_trwl_f<<endl;
  report<<"laa_tr_m"<<endl;
  report<<CAA_landed_trwl_m<<endl;
  report<<"$daa_dead_f"<<endl;
  report<<DAA_dead_f<<endl;
  report<<"$daa_dead_m"<<endl;
  report<<DAA_dead_m<<endl;
  report<<"$daa_f"<<endl;
  report<<DAA_f<<endl;
  report<<"$daa_m"<<endl;
  report<<DAA_m<<endl;

   // ABC catch-at-age, discards-at-age, etc.
  report<<"$caa_abc_dead_f"<<endl;
  report<<CAA_ABC_dead_f<<endl;
  report<<"$caa_abc_dead_m"<<endl;
  report<<CAA_ABC_dead_m<<endl;
  report<<"$laa_abc_fg_f"<<endl;
  report<<CAA_ABC_landed_FG_f<<endl;
  report<<"laa_abc_fg_m"<<endl;
  report<<CAA_ABC_landed_FG_m<<endl;
  report<<"$laa_abc_tr_f"<<endl;
  report<<CAA_ABC_landed_trwl_f<<endl;
  report<<"laa_abc_tr_m"<<endl;
  report<<CAA_ABC_landed_trwl_m<<endl;
  report<<"$daa_abc_dead_f"<<endl;
  report<<DAA_ABC_dead_f<<endl;
  report<<"$daa_abc_dead_m"<<endl;
  report<<DAA_ABC_dead_m<<endl;
  report<<"$daa_abc_f"<<endl;
  report<<DAA_ABC_f<<endl;
  report<<"$daa_abc_m"<<endl;
  report<<DAA_ABC_m<<endl;

   // OFL catch-at-age, discards-at-age, etc.
  report<<"$caa_ofl_dead_f"<<endl;
  report<<CAA_OFL_dead_f<<endl;
  report<<"$caa_ofl_dead_m"<<endl;
  report<<CAA_OFL_dead_m<<endl;
  report<<"$laa_ofl_fg_f"<<endl;
  report<<CAA_OFL_landed_FG_f<<endl;
  report<<"laa_ofl_fg_m"<<endl;
  report<<CAA_OFL_landed_FG_m<<endl;
  report<<"$laa_ofl_tr_f"<<endl;
  report<<CAA_OFL_landed_trwl_f<<endl;
  report<<"laa_ofl_tr_m"<<endl;
  report<<CAA_OFL_landed_trwl_m<<endl;
  report<<"$daa_ofl_dead_f"<<endl;
  report<<DAA_OFL_dead_f<<endl;
  report<<"$daa_ofl_dead_m"<<endl;
  report<<DAA_OFL_dead_m<<endl;
  report<<"$daa_ofl_f"<<endl;
  report<<DAA_OFL_f<<endl;
  report<<"$daa_ofl_m"<<endl;
  report<<DAA_OFL_m<<endl;

   // Revenue-at-age
  report<<"$raa"<<endl;
  report<<revenue_age<<endl;
  report<<"$raa_abc"<<endl;
  report<<revenue_age_ABC<<endl;
  report<<"$raa_ofl"<<endl;
  report<<revenue_age_OFL<<endl;

   // Full YPR, SPR, RevenuePR (RPR) results
  report<<"$fmax_ypr"<<endl;
  report<<Fmax_ypr<<endl;
  report<<"$ypr_fmax"<<endl;
  report<<ypr_Fmax<<endl;
  report<<"$spr_fmax"<<endl;
  report<<spr_Fmax<<endl;
  report<<"$rpr_fmax_curr"<<endl;
  report<<rpr_Fmax_curr<<endl;
  report<<"$rpr_fmax_avg"<<endl;
  report<<rpr_Fmax_avg<<endl;
  report<<"$rpr_fmax_max"<<endl;
  report<<rpr_Fmax_max<<endl;
  report<<"$loc_Fmax"<<endl;
  report<<loc_Fmax<<endl;

  report<<"$f_f40_alt"<<endl;
  report<<F_F40<<endl;
  report<<"$ypr_f40"<<endl;
  report<<ypr_F40<<endl;
  report<<"$spr_f40"<<endl;
  report<<spr_F40<<endl;
  report<<"$rpr_f40_curr"<<endl;
  report<<rpr_F40_curr<<endl;
  report<<"$rpr_f40_avg"<<endl;
  report<<rpr_F40_avg<<endl;
  report<<"$rpr_f40_max"<<endl;
  report<<rpr_F40_max<<endl;
  report<<"$loc_F40"<<endl;
  report<<loc_F40<<endl;

  report<<"$f_max_rpr_curr"<<endl;
  report<<F_max_rpr_curr<<endl;
  report<<"$ypr_rpr_max_curr"<<endl;
  report<<ypr_max_rpr_curr<<endl;
  report<<"$spr_rpr_max_curr"<<endl;
  report<<spr_max_rpr_curr<<endl;
  report<<"$rpr_max_curr"<<endl;
  report<<rpr_max_curr<<endl;
  report<<"$loc_rpr_curr_max"<<endl;
  report<<loc_rpr_curr_max<<endl;

  report<<"$f_max_rpr_avg"<<endl;
  report<<F_max_rpr_avg<<endl;
  report<<"$ypr_rpr_max_avg"<<endl;
  report<<ypr_max_rpr_avg<<endl;
  report<<"$spr_rpr_max_avg"<<endl;
  report<<spr_max_rpr_avg<<endl;
  report<<"$rpr_max_avg"<<endl;
  report<<rpr_max_avg<<endl;
  report<<"$loc_rpr_avg_max"<<endl;
  report<<loc_rpr_avg_max<<endl;

  report<<"$f_max_rpr_max"<<endl;
  report<<F_max_rpr_max<<endl;
  report<<"$ypr_rpr_max_max"<<endl;
  report<<ypr_max_rpr_max<<endl;
  report<<"$spr_rpr_max_max"<<endl;
  report<<spr_max_rpr_max<<endl;
  report<<"$rpr_max_max"<<endl;
  report<<rpr_max_max<<endl;
  report<<"$loc_rpr_max_max"<<endl;
  report<<loc_rpr_max_max<<endl;
  
  report<<"$f_ypr"<<endl;
  report<<F_YPR<<endl;
  report<<"$ypr"<<endl;
  report<<ypr<<endl;
  report<<"$spr"<<endl;
  report<<spr<<endl;
  report<<"$rpr_curr"<<endl;
  report<<rpr_curr<<endl;
  report<<"$rpr_avg"<<endl;
  report<<rpr_avg<<endl;
  report<<"$rpr_max"<<endl;
  report<<rpr_max<<endl;
  
  report<<"$ypr_f40_age"<<endl;
  report<<ypr_f40_age<<endl;
  report<<"$spr_f40_age"<<endl;
  report<<spr_f40_age<<endl;
  report<<"$rpr_f40_age_curr"<<endl;
  report<<rpr_f40_age_curr<<endl;
  report<<"$rpr_f40_age_avg"<<endl;
  report<<rpr_f40_age_avg<<endl;
  report<<"$rpr_f40_age_max"<<endl;
  report<<rpr_f40_age_max<<endl;

   // some extra debug stuff
  report<<"$obj_fun"<<endl;
  report<<obj_fun<<endl; 
  report<<"$sprpen"<<endl;
  report<<sprpen<<endl;

  save_gradients(gradients);

RUNTIME_SECTION
  convergence_criteria 1.e-7  
  maximum_function_evaluations 20000

TOP_OF_MAIN_SECTION
 gradient_structure::set_MAX_NVAR_OFFSET(1000);
 gradient_structure::set_NUM_DEPENDENT_VARIABLES(1000);
 gradient_structure::set_GRADSTACK_BUFFER_SIZE(1000000);
 gradient_structure::set_CMPDIF_BUFFER_SIZE(10000000);
 arrmblsize=3900000;
