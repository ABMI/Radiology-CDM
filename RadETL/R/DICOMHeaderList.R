#' 'DICOMHeaderList'
#'
#' DICOMHeaderList function will read metadata of all DICOM files under DICOMFolderPath
#'
#'
#' @param DICOMFolderPath function will read all of the DICOM files under this pathway
#' @param core you can set CPU core in order to make the computing process fast
#' @import ParallelLogger
#' @importFrom oro.dicom "readDICOM"
#'
#'
#' @return A list containing metadata of DICOM
#' @examples DICOMHeaderList(DICOMFolderPath, core=4)
#' @export

DICOMHeaderList<-function(DICOMFolderPath, core=4){
    RadiologyFileList<-list.files(path = DICOMFolderPath, full.names=T, recursive=T, pattern='\\.dcm$')
    cluster <- ParallelLogger::makeCluster(numberOfThreads = core)
    result <- ParallelLogger::clusterApply(cluster, 1:length(RadiologyFileList), function(x) {
        tryCatch({FileMetadata<-oro.dicom::readDICOM(RadiologyFileList[x], recursive = T, verbose = F, pixelData = F)
        return(FileMetadata$hdr[1])},
        error= function(e) return(list(data.frame(group='NA', element='NA', name='NA', code='NA', length='NA', value='NA', sequence='NA')
        )))
    })
    return(result)
}
