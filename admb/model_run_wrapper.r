
#########################################
### setting up the directories
#########################################

  direct_master<-wd 
  
  #Build diagnostics/results folder
  dir.create(paste0(direct_master,"\\Outputs",sep=""))
  dir_out<-paste0(direct_master,"\\Outputs",sep="")
  dir.create(paste0(direct_master,"\\Results",sep=""))
  dir_res<-paste0(direct_master,"\\Results",sep="")
  
    for(j in 1:nsim){
      
      dir.create(paste0(dir_out,"\\Run_",j,sep=""))

      #Move folders and .dat files  
      invisible(file.copy(from=paste0(direct_master,"\\",OM_name,".exe",sep=""),to=paste0(dir_out,"\\Run_",j,sep="")))
      invisible(file.copy(from=paste0(direct_master,"\\",OM_name,".dat",sep=""),to=paste0(dir_out,"\\Run_",j,sep="")))

      #change seed for OM
      setwd(paste0(dir_out,"\\Run_",j,sep=""))
      
      SIM.DAT=readLines(paste0(OM_name,".dat"),n=-1)
      SIM.DAT[(grep("RNG_seed_rec_full",SIM.DAT)+1)]=4+j
      SIM.DAT[(grep("RNG_seed_rec_recent",SIM.DAT)+1)]=1+j

      writeLines(SIM.DAT,paste0(OM_name,".dat"))
      
      #run the OM
      invisible(shell(paste0(OM_name," -nox"),wait=T))
      
      invisible(file.copy(from=paste0(dir_out,"\\Run_",j,"\\",OM_name,".rep",sep=""),to=paste0(dir_res,"\\",scen_nm,"_Iter_",j,".rep",sep="")))
      
    }
   