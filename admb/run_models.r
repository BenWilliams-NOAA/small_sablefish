rm(list=(ls()))

###################################
# Sim Settings
##################################

# Set number of simulations to perform
nsim <- 500
OM_name <- "discard_proj"                      #name of the OM you are wanting to run

summ_res_dir <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\__Summarized_Results"      # folder to save summarized results for all runs


##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Scenarios for the June NPFMC Analysis (To Go In Doc)
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################

scen_nm <- "Base"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Base"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hist_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hist_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hist_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Rec_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_No_Disc" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Rec_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Rec_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Rec_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Lo_Hi_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Lo_Hi_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Lo_Hi_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Lo_Hi_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hi_Lo_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hi_Lo_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hi_Lo_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hi_Lo_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")



##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Full ABC Harvested Each Year
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Full_ABC_Rec_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Rec_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Rec_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Rec_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Lo_Hi_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_No_Disc" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Lo_Hi_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Lo_Hi_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Lo_Hi_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hist_recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hist_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hist_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hist_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hi_Lo_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hi_Lo_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hi_Lo_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Full_ABC_Hi_Lo_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")



##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Retention Age-4
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Age-4_Ret_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-4_Ret_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Retention Age-5
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Age-5_Ret_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Age-5_Ret_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Logistic Retention
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Log_Ret_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Log_Ret_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")



##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Average Price
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################

scen_nm <- "Price_Avg_Hist_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hist_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Rec_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Rec_Recr_No_Disc_SC" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Lo_Hi_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Lo_Hi_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Hi_Lo_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hi_Lo_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Avg_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Avg\\Price_Avg_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")



##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Variable Price (linear relationship between low in 2023 and high in 2017)
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################

scen_nm <- "Price_Var_Hist_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hist_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Rec_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Rec_Recr_No_Disc_SC" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Lo_Hi_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Lo_Hi_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Hi_Lo_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hi_Lo_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Price_Var_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Price_Var\\Price_Var_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")





##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Trawl Proportion at 10% (low value, close to time series mean for last 30 years)
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Trwl_10%_Hi_Lo_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hi_Lo_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Hi_Lo_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hi_Lo_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Hi_Lo_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hi_Lo_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Hi_Lo_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hi_Lo_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Hist_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hist_Recr_DMR_12%" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Hist_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hist_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Hist_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hist_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Hist_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Hist_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Lo_Hi_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Lo_Hi_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Lo_Hi_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Lo_Hi_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Lo_Hi_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Lo_Hi_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Lo_Hi_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Lo_Hi_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Rec_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Rec_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Rec_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Rec_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Trwl_10%_Rec_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Rec_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Trwl_10%_Rec_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Trwl_Prop_10%\\Trwl_10%_Rec_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")




##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with a Capped HCR (15kt total landings) and Full ABC harvested
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Cap_HCR_Hi_Lo_Recr_DMR_12%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hi_Lo_Recr_DMR_12%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hi_Lo_Recr_DMR_20%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hi_Lo_Recr_DMR_20%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hi_Lo_Recr_DMR_35%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hi_Lo_Recr_DMR_35%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hi_Lo_Recr_No_Disc_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hi_Lo_Recr_No_Disc_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_DMR_12%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hist_Recr_DMR_12%_Full_ABC" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_DMR_20%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hist_Recr_DMR_20%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_DMR_35%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hist_Recr_DMR_35%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_No_Disc_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Hist_Recr_No_Disc_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_DMR_12%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Lo_Hi_Recr_DMR_12%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_DMR_20%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Lo_Hi_Recr_DMR_20%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_DMR_35%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Lo_Hi_Recr_DMR_35%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_No_Disc_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Lo_Hi_Recr_No_Disc_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_DMR_12%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Rec_Recr_DMR_12%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_DMR_20%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Rec_Recr_DMR_20%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_DMR_35%_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Rec_Recr_DMR_35%_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_No_Disc_Full_ABC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR\\Cap_HCR_Rec_Recr_No_Disc_Full_ABC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")




##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with a Capped HCR (15kt total landings) and Full ABC harvested and the Variable Price Option Implemented
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Cap_HCR_Hi_Lo_Recr_DMR_12%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hi_Lo_Recr_DMR_12%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hi_Lo_Recr_DMR_20%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hi_Lo_Recr_DMR_20%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hi_Lo_Recr_DMR_35%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hi_Lo_Recr_DMR_35%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hi_Lo_Recr_No_Disc_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hi_Lo_Recr_No_Disc_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_DMR_12%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hist_Recr_DMR_12%_Full_ABC_Price_Var" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_DMR_20%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hist_Recr_DMR_20%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_DMR_35%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hist_Recr_DMR_35%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Hist_Recr_No_Disc_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Hist_Recr_No_Disc_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_DMR_12%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Lo_Hi_Recr_DMR_12%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_DMR_20%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Lo_Hi_Recr_DMR_20%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_DMR_35%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Lo_Hi_Recr_DMR_35%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Lo_Hi_Recr_No_Disc_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Lo_Hi_Recr_No_Disc_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_DMR_12%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Rec_Recr_DMR_12%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_DMR_20%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Rec_Recr_DMR_20%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_DMR_35%_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Rec_Recr_DMR_35%_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Cap_HCR_Rec_Recr_No_Disc_Full_ABC_Price_Var"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Cap_HCR_Price_Var\\Cap_HCR_Rec_Recr_No_Disc_Full_ABC_Price_Var"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")





##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with an assumed recruitment regime shift (change R0 to recent mean)
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Reg_Shift_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Reg_Shift_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Hi_Lo_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hi_Lo_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hist_Recr_DMR_20%_SC" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Reg_Shift_Hist_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Hist_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Lo_Hi_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Lo_Hi_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Reg_Shift_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Reg_Shift_Rec_Recr_No_Disc_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Recr_Reg_Shift\\Reg_Shift_Rec_Recr_No_Disc_SC"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")






##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Hindcast Sims (start in year 2017 when prices high, ABC low and recruitment just starting to enter fishery...how would things have been different with a MSL?)
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################

scen_nm <- "Hind_Hi_Lo_Recr_DMR_12%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hi_Lo_Recr_DMR_12%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hi_Lo_Recr_DMR_20%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hi_Lo_Recr_DMR_20%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hi_Lo_Recr_DMR_35%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hi_Lo_Recr_DMR_35%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hi_Lo_Recr_No_Disc_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hi_Lo_Recr_No_Disc_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_DMR_12%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hist_Recr_DMR_12%_Full_ABC_Var_Price" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_DMR_20%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hist_Recr_DMR_20%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_DMR_35%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hist_Recr_DMR_35%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_No_Disc_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Hist_Recr_No_Disc_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_DMR_12%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Lo_Hi_Recr_DMR_12%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_DMR_20%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Lo_Hi_Recr_DMR_20%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_DMR_35%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Lo_Hi_Recr_DMR_35%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_No_Disc_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Lo_Hi_Recr_No_Disc_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Rec_Recr_DMR_12%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Rec_Recr_DMR_12%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Hind_Rec_Recr_DMR_20%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Rec_Recr_DMR_20%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Rec_Recr_DMR_35%_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Rec_Recr_DMR_35%_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Hind_Rec_Recr_No_Disc_Full_ABC_Var_Price"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Base\\Hind_Rec_Recr_No_Disc_Full_ABC_Var_Price"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")




##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Hindcast Sims with capped HCR (start in year 2017 when prices high, ABC low and recruitment just starting to enter fishery...how would things have been different with a MSL and capped HCR?)
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################

scen_nm <- "Hind_Hi_Lo_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hi_Lo_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hi_Lo_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hi_Lo_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hi_Lo_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hi_Lo_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hi_Lo_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hi_Lo_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hist_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR" 

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hist_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hist_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Hist_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Hist_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Lo_Hi_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Lo_Hi_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Lo_Hi_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Lo_Hi_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Lo_Hi_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Rec_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Rec_Recr_DMR_12%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Hind_Rec_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Rec_Recr_DMR_20%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")

scen_nm <- "Hind_Rec_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Rec_Recr_DMR_35%_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")


scen_nm <- "Hind_Rec_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Hindcast_Cap_HCR\\Hind_Rec_Recr_No_Disc_Full_ABC_Var_Price_Cap_HCR"  

setwd(wd)
source("model_run_wrapper.r")
setwd(wd)
source("dan_data_clean.R")






