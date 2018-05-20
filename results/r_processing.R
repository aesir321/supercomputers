library(data.table)
library(ggplot2)
library(dplyr)

setwd( "C:/Users/Patrick/Desktop/sc3/results" )
datadir <- "C:/Users/Patrick/Desktop/sc3/results"
file_sb <- file.path(datadir, "processed_sb.txt")
file_hw <- file.path(datadir, "processed_hw.txt")


dt <- fread(file_sb)
colnames(dt) <- c("size", "comp_time", "mpi_time", "real_time")
dt_sb <- dt[, lapply(.SD, mean), by="size", .SDcols = c("comp_time", "mpi_time", "real_time")]
dt_sb_SD <- dt[, lapply(.SD, sd), by="size", .SDcols = c("comp_time", "mpi_time", "real_time")]
colnames(dt_sb_SD) <- c("size", "sd_comp", "sd_mpi", "sd_real")
dt_sb[, arch:="sb"]
dt_sb_SD[,arch:="sb"]


dt2 <- fread(file_hw)
colnames(dt2) <- c("size", "comp_time", "mpi_time", "real_time")
dt_hw <- dt2[, lapply(.SD, mean), by="size", .SDcols = c("comp_time", "mpi_time", "real_time")]
dt_hw_SD <- dt2[, lapply(.SD, sd), by="size", .SDcols = c("comp_time", "mpi_time", "real_time")]
colnames(dt_hw_SD) <- c("size", "sd_comp", "sd_mpi", "sd_real")
dt_hw[, arch:="hw"]
dt_hw_SD[,arch:="hw"]

data_data <- full_join(dt_hw, dt_sb)
error_data <- full_join(dt_sb_SD, dt_hw_SD)
all_data <- left_join(data_data, error_data, by = c("size","arch"))

ggplot(all_data, aes(size, mpi_time, color=arch)) +
  geom_point(alpha=0.3) +
  geom_errorbar(aes(ymin=mpi_time-sd_mpi, ymax=mpi_time+sd_mpi)) +
  ggtitle("Cannon MPI time vs square matrix size") +
  labs(x="square matrix number of rows", y="mpi time (s)") +
  ggsave(filename="mpi_time.png", dpi=600)
  
  ggplot(all_data, aes(size, real_time, color=arch)) +
    geom_point(alpha=0.3) +
    geom_errorbar(aes(ymin=real_time-sd_real, ymax=real_time+sd_real)) +
    ggtitle("Cannon time to solution vs square matrix size") +
    labs(x="square matrix number of rows", y="total time (s)") +
  ggsave(filename="real_time.png", dpi=600)
  
  ggplot(all_data, aes(size, comp_time, color=arch)) +
    geom_point(alpha=0.3) +
    geom_errorbar(aes(ymin=comp_time-sd_comp, ymax=comp_time+sd_comp)) +
    ggtitle("Cannon computation time vs square matrix size") +
    labs(x="square matrix number of rows", y="compute time (s)") +
  ggsave(filename="comp_time.png", dpi=600)
  
  ggplot(all_data, aes(size, real_time, color=arch)) +
    geom_point(alpha=0.3) +
    scale_x_log10() +
    scale_y_log10() +
    labs(x="log10(square matrix number of rows)", y="log10(real time)") +
    ggtitle("log-log - Real time vs matrix size") +
    ggsave(filename="log_log_real.png", dpi=600)
    
  
