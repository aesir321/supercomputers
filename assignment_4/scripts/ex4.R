#MPI IO assignment 4

library(data.table)
library(ggplot2)
library(dplyr)

setwd( "C:/Users/Patrick/Desktop/MegaSync/results/as4" )
datadir <- "C:/Users/Patrick/Desktop/MegaSync/results/as4"
file_sb <- file.path(datadir, "mpi_io_sb.txt")
file_hw <- file.path(datadir, "mpi_io_hw.txt")


sb_raw <- fread(file_sb)
dt_sb <- sb_raw[, lapply(.SD, mean), by="size", .SDcols = setdiff(colnames(sb_raw), "size")]
dt_sb_SD <- sb_raw[, lapply(.SD, sd), by="size", .SDcols = setdiff(colnames(sb_raw), "size")]
colnames(dt_sb_SD) <- c("size", paste0("sd_", setdiff(colnames(sb_raw), "size")))
dt_sb[, arch:="sb"]
dt_sb_SD[,arch:="sb"]


hw_raw <- fread(file_hw)
dt_hw <- hw_raw[, lapply(.SD, mean), by="size", .SDcols = setdiff(colnames(hw_raw), "size")]
dt_hw_SD <- hw_raw[, lapply(.SD, sd), by="size", .SDcols = setdiff(colnames(hw_raw), "size")]
colnames(dt_hw_SD) <- c("size", paste0("sd_", setdiff(colnames(hw_raw), "size")))
dt_hw[, arch:="hw"]
dt_hw_SD[,arch:="hw"]

data_data <- full_join(dt_hw, dt_sb)
error_data <- full_join(dt_sb_SD, dt_hw_SD)
all_data <- left_join(data_data, error_data, by = c("size","arch"))

ggplot(all_data, aes(size, mpi_time, color=arch)) +
  geom_point(size=2, alpha=0.3) +
  geom_errorbar(aes(ymin=mpi_time-sd_mpi_time, ymax=mpi_time+sd_mpi_time)) +
  ggtitle("Cannon MPI time, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="mpi time (s)") +
  expand_limits(y=0) +
  ggsave(filename="mpi_time.png", dpi=600)

ggplot(all_data, aes(size, real_time, color=arch)) +
  geom_point(size=2, alpha=0.3) +
  geom_errorbar(aes(ymin=real_time-sd_real_time, ymax=real_time+sd_real_time)) +
  ggtitle("Cannon total run time, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="time (s)") +
  expand_limits(y=0) +
  ggsave(filename="total_run_time.png", dpi=600)

ggplot(all_data, aes(size, comp_time, color=arch)) +
  geom_point(size = 2, alpha=0.3) +
  geom_errorbar(aes(ymin=comp_time-sd_comp_time, ymax=comp_time+sd_comp_time)) +
  ggtitle("Cannon computation time, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="compute time (s)") +
  expand_limits(y=0) +
  ggsave(filename="comp_time.png", dpi=600)

###new plots
ggplot(all_data, aes(size, init_time, color=arch)) +
  geom_point(size = 2, alpha=0.3) +
  geom_errorbar(aes(ymin=init_time-sd_init_time, ymax=init_time+sd_init_time)) +
  ggtitle("Cannon initialisation time, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="initialisation time (s)") +
  expand_limits(y=0) +
  ggsave(filename="init_time.png", dpi=600)


ggplot(all_data, aes(size, output_time, color=arch)) +
  geom_point(size = 2, alpha=0.3) +
  geom_errorbar(aes(ymin=output_time-sd_output_time, ymax=output_time+sd_output_time)) +
  ggtitle("Cannon output time, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="output time (s)") +
  expand_limits(y=0) +
  ggsave(filename="output_time.png", dpi=600)


ggplot(all_data, aes(size, real_time, color=arch)) +
  geom_point(size=2, alpha=0.3) +
  scale_x_log10() +
  scale_y_log10() +
  labs(x="log10(square matrix number of rows)", y="log10(real time)") +
  ggtitle("log-log - Real time to solution,(MPI IO algorithm)") +
  ggsave(filename="log_log_real.png", dpi=600)


melted <- all_data %>% melt(id.vars = c("size", "arch"),
                        measure.vars = c("comp_time", "mpi_time", "init_time", "output_time", "real_time"), 
                        variable.name = "time_metric",
                        value.name = "time")

ggplot(melted, aes(x=size, y=time, col = arch)) +
  geom_point(size=2, alpha=0.3) +
  facet_wrap(~time_metric)



melted_hw <- melted %>% filter(arch == "hw")
melted_sb <- melted %>% filter(arch == "sb")

ggplot(melted_hw, aes(x=size, y=time, col=time_metric)) +
  geom_point(alpha=0.8, size=2) +
  ggtitle("Cannon times for haswell architecture, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="time (s)") +
  expand_limits(y=0) +
  ggsave(filename="hw_arch_times.png", dpi=600)

ggplot(melted_sb, aes(x=size, y=time, col=time_metric)) +
  geom_point(alpha=0.8, size=2) +
  ggtitle("Cannon times for sandy bridge architecture, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="time (s)") +
  expand_limits(y=0) +
  ggsave(filename="sb_arch_times.png", dpi=600)

melted_hw_nort <- melted %>% filter(arch == "hw", time_metric != "real_time")
melted_sb_nort <- melted %>% filter(arch == "sb", time_metric != "real_time")

ggplot(melted_hw_nort, aes(x=size, y=time, col=time_metric)) +
  geom_point(alpha=0.8, size=2) +
  ggtitle("Cannon times for haswell architecture, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="time (s)") +
  expand_limits(y=0) +
  ggsave(filename="hw_arch_times_nort.png", dpi=600)

ggplot(melted_sb_nort, aes(x=size, y=time, col=time_metric)) +
  geom_point(alpha=0.8, size=2) +
  ggtitle("Cannon times for sandy bridge architecture, (MPI IO algorithm)") +
  labs(x="square matrix number of rows", y="time (s)") +
  expand_limits(y=0) +
  ggsave(filename="sb_arch_times_nort.png", dpi=600)


###############################################################################
# Speedup from original code - just for interest

###### Now process the non-baseline files


dt_nb_sb <- fread(file_sb)
dt_nb_hw <- fread(file_hw)


nb_hw <- clean_data(dt_nb_hw)
nb_sb <- clean_data(dt_nb_sb)


bl_sb <- clean_data(dt)
bl_hw <- clean_data(dt2)

#now calculate the speedups

getSpeedups <-function (df, bl) {
  temp <- bl[,2:4] / df[,2:4]
  temp$size <- bl$size
  temp[,5:7] <-  bl[,2:4] / df[,2:4] * sqrt ( (bl[,5:7])^2 + (df[,5:7])^2 )
  colnames(temp) <- c("compute", "MPI", "real","size", "sd_dcomp", "sd_dmpi", "sd_dreal")
  return(temp[,c(4,1,2,3,5,6,7)])
}

su_nb_sb <- getSpeedups(nb_sb, bl_sb)
su_nb_sb$arch <- "sb"
su_nb_sb$alg <- "nonblocking"
su_nb_hw <- getSpeedups(nb_hw, bl_hw)
su_nb_hw$arch <- "hw"
su_nb_hw$alg <- "nonblocking"


bind_speedup_data <- function(df1, df2) {
  cols_in_common <- c("size","arch","alg","type")
  speedup <- rbind(df1, df2) 
  #Reshape the data for plotting
  su_times <- speedup %>% data.table::melt(id.vars = c("size", "arch", "alg"),
                                           measure.vars = c("compute", "MPI", "real"),
                                           variable.name = "type",
                                           value.name = "time")
  su_errors <- speedup %>% data.table::melt(id.vars = c("size", "arch", "alg"),
                                            measure.vars = c("sd_dcomp", "sd_dmpi", "sd_dreal"),
                                            variable.name = "type",
                                            value.name = "error")
  su_times[cols_in_common] <- lapply(su_times[cols_in_common], factor)
  su_errors[cols_in_common] <- lapply(su_errors[cols_in_common], factor)
  #Manually fix the level assignment so it matches
  levels(su_errors$type) <- c("compute", "MPI", "real")
  su_times$type<-factor(su_times$type, levels=c("compute", "MPI", "real"))
  su_errors$type<-factor(su_errors$type, levels=c("compute", "MPI", "real"))
  joined <- inner_join(su_times, su_errors, by = cols_in_common )
  return(joined)
}


hw_speedup <-bind_speedup_data(su_nb_hw, su_os_hw)
sb_speedup <-bind_speedup_data(su_nb_sb, su_os_sb)



ggplot(hw_speedup, aes(size, time, col=type)) +
  facet_grid(alg ~.) +
  geom_point(size=2, alpha=.7) +
  scale_y_continuous(limits = c(0,2)) + 
  geom_errorbar(aes(ymin=time-error, ymax=time+error, width=.1)) +
  labs(x="square matrix number of rows", y="speedup ratio T/T_baseline") +
  ggtitle("Cannon algorithm times vs matrix size on Haswell architecture")
ggsave(filename="hw_speedup.png", dpi=600)

ggplot(sb_speedup, aes(size, time, col=type)) +
  facet_grid(alg ~.) +
  geom_point(size=2, alpha=.7) +
  scale_y_continuous(limits = c(0,2)) + 
  geom_errorbar(aes(ymin=time-error, ymax=time+error, width=.1)) +
  labs(x="square matrix number of rows", y="speedup ratio T/T_baseline") +
  ggtitle("Cannon algorithm times vs matrix size on Sandy Bridge architecture")
ggsave(filename="sb_speedup.png", dpi=600)


###################
setwd( "C:/Users/Patrick/Desktop/MegaSync/results/as4" )
datadir <- "C:/Users/Patrick/Desktop/MegaSync/results/as4"
blah <- file.path(datadir, "collective_nonblocking_sb.txt") 
blax <- fread(blah)

