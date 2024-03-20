rm(list=(ls()))

###################################
# Sim Settings
##################################

# Set number of simulations to perform
nsim <-500
OM_name<-"discard_proj" #name of the OM you are wanting to run



##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Scenarios for the June NPFMC Analysis (To Go In Doc)
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################

scen_nm <- "Base"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Base"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hist_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hist_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hist_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_No_Disc" 

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")




##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Full ABC Harvested Each Year
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Full_ABC_Rec_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Rec_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Rec_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Rec_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Rec_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Lo_Hi_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_No_Disc" 

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Lo_Hi_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Lo_Hi_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Lo_Hi_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Lo_Hi_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hist_recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hist_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hist_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hist_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hist_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hi_Lo_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hi_Lo_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hi_Lo_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Full_ABC_Hi_Lo_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Full ABC\\Full_ABC_Hi_Lo_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Retention Age-4
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Age-4_Ret_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-4_Ret_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_4\\Age-4_Ret_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Retention Age-5
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Age-5_Ret_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Age-5_Ret_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Ret_Age_5\\Age-5_Ret_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")



##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Logistic Retention
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################


scen_nm <- "Log_Ret_Rec_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Rec_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Rec_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Rec_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Rec_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Rec_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Lo_Hi_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Lo_Hi_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Lo_Hi_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Lo_Hi_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Lo_Hi_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Lo_Hi_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Hist_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hist_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Hist_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hist_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Hist_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hist_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Hi_Lo_Recr_DMR_35%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hi_Lo_Recr_DMR_35%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Hi_Lo_Recr_DMR_20%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hi_Lo_Recr_DMR_20%_SC"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Log_Ret_Hi_Lo_Recr_DMR_12%_SC"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\Log_Ret\\Log_Ret_Hi_Lo_Recr_DMR_12%_SC"  

setwd(wd)
source("model_run_wrapper.r")



##################################################################################################################################
#------------------------------------------------------------------------------------------------------------------------------
# Repeat Main Sims with Average Price
#------------------------------------------------------------------------------------------------------------------------------
#####################################################################################################################################

scen_nm <- "Base"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Base"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hist_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hist_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hist_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hist_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_No_Disc" 

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Rec_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Rec_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Lo_Hi_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Lo_Hi_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_No_Disc"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_No_Disc"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_DMR_12%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_12%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_DMR_20%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_20%"  

setwd(wd)
source("model_run_wrapper.r")


scen_nm <- "Hi_Lo_Recr_DMR_35%"
wd <- "C:\\Users\\daniel.goethel\\Desktop\\Discard Projections (June 2024 SSC)\\ADMB Code\\Model Runs\\_Main Scenarios (SSC)\\Hi_Lo_Recr_DMR_35%"  

setwd(wd)
source("model_run_wrapper.r")