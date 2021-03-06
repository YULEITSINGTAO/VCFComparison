## Union of intervals
union_bed_df <- function(bed_df, verbose = FALSE){
    union_df_list <- list()
    chromosomes <- paste0("chr", c(1:22,"X","Y"))
    for (chr in chromosomes) {
        chr_bed_df <- bed_df %>% dplyr::filter(Chr == chr)
        if (nrow(chr_bed_df)==0){
            union_df_intervals <- data.frame(Chr = NA, Start = NA, End = NA)
            if (verbose == TRUE){
            print(paste("There is no SVs in", chr))
            }
        }else{
            chr_bed_df_intervals <- intervals::Intervals(chr_bed_df %>% dplyr::select(Start, End))
            union_df_intervals <- as.data.frame(intervals::interval_union(chr_bed_df_intervals))
            union_df_intervals <- cbind(chr, union_df_intervals)
            colnames(union_df_intervals) <- c("Chr", "Start", "End")
        }

        union_df_list[[chr]] <- union_df_intervals

    }
    union_df <- na.omit(do.call(rbind, union_df_list))
    rownames(union_df) <- NULL
    return(union_df)

}

union_bed_list <- function(bed_list, verbose = FALSE){
    for (i in names(bed_list)){
        bed_list[[i]] <- union_bed_df(bed_list[[i]])

    }
    return(bed_list)
}


