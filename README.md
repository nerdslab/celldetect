# Cell detection via sparse approximation

This repository contains Matlab code for _detecting cells in both 3D image volumes and 2D images_. 

You can find further details about how we apply the methods in this repo to analyze mm-scale brain volumes in the following paper:

__Dyer, Eva L., et al. "Quantifying mesoscale neuroanatomy using X-ray microtomography", eNeuro 25 September 2017, 4 (5) ENEURO.0195-17.2017 [[Link to Paper]](https://doi.org/10.1523/ENEURO.0195-17.2017).__

If you use any of the code or datasets in this repo, please cite this paper. 
Please direct any questions to Eva Dyer at evadyer{at}gatech{dot}edu.
***

### Overview of the method ###
The input to our cell detection algorithm is a "probability map" that encodes the probability that each voxel/pixel corresponds to a cell body. The output is a list of the position of all detected cells as well as a map of the cells that is the same size as the input image or volume.

The main functions used for cell detection in the 3D and 2D case are:
- [Centroids, Nmap] = OMP_ProbMap(Probmap,ptr,presid,startsz,dilatesz,kmax); (3D)
- [Centroids,Nmap] = OMP_ProbMap2D(Probmap,ptr,presid,startsz,dilatesz,kmax); (2D)

The parameters that you need to set:
- _ptr_ is the probability threshold - all probabilities less than ptr will be set to zero
- _presid_ is the stopping criterion - when the correlation between the cell template and the probmap is less than presid, the algorithm terminates
- _startsz_ is the size of the spherical/circular template used (set this to be the average radius of cells)
- _dilatesz_ is the size of the dilation template used to remove cells after they are detected (usually set to 1 or 2)
- _kmax_ is the maximum number of cells you want to detect (a way to stop the algorithm early)

***

### Computing a probability map for your image ###
You must supply a probability map as input for the cell detection algorithm. There are a few options depending on the complexity of your data.

1. _Gausian Mixture Model_: We supply a simple unsupervised method for computing a cell probability map which uses a Gaussian Mixture Model. This can provide a reasonable output when the color (pixel intensities) of the cells is different from the background in the image. 

2. _Ilastik pixel classifier_: When an intensity-based classifier is not sufficient for your data, you can compute a probability map with [Ilastik](http://ilastik.org). The ilastik team provides great documentation on their website for creating a [Pixel Classifier](http://ilastik.org/documentation/pixelclassification/pixelclassification). You can also see an example of a Pixel Classifier in our demo data (see below for a link to download our data and classifiers).

3. _Use the image_: In images where the intensity of the foreground (cell) is significantly different from the background, you can simply use the image, but you need to rescale your image first so the background pixels have values close to zero and cell pixels have values close to one.

***
### Download Data ###
If you want to run any of the demos in this repository, please download the data from [DropBox](https://www.dropbox.com/s/f21jpjad487f1nv/celldetect-demo-data.zip?dl=0).
***
### Example 1 - Run the 3D cell finding algorithm on X-ray microCT data
To begin, run the following script:
```matlab
script_cellfinder
```
This script will run the main cell finding routine ___OMP_ProbMap.m___ on the test data in the celldetect folder. The output includes two variables: (1) _Centroids_out_, a 10x4 matrix with the position (x,y,z) first 10 detected cells centroids (columns 1-3) and the correlation value between all detected cells and theinput probability map (column 4). (2) _Nmap_out_, a 200x200x100 matrix with all of the detected cells labeled with a unique ID (and the remaining volume labeled w/ zeros).

To find more cells in the volume, set kmax to a larger number. The variable _kmax_ controls the maximum number of iterations of the algorithms (and constrains the maximum number of detected cells). 

To find the top 100 cells, call the greedy sphere finder method again (this will take a few minutes).
```matlab
kmax = 100; 
[Centroids_out,Nmap_out] = OMP_ProbMap(Probmap,ptr,presid,startsz,dilatesz,kmax);
```

#### Visualize the detected cells overlaid on the probability map ####

  ```matlab
figure; 
for i=1:size(Prob,3) 
    imagesc(Prob(:,:,i)-(Nmap(:,:,i)~=0)), 
    pause, 
end
  ```
***  

### Example 2 - Compute a probability map using a Gaussian Mixture Model (GMM) ###
To compute a cell probability map using a GMM, run our demo on X-ray data:
```matlab
script_runGMMseg
```

***  
  ### Example 3 - Run the 2D cell finding algorithm on a Nissl image ###
To test our methods on 2D image data, run the following script:
```matlab
script_run2Dcelldetect
```
This script will output the centroids and map of the detected cell bodies (each cell is labeled with a unique ID). If you use the test data (from the Allen Institute Reference Atlas) provided in this example, please cite the following paper:

Lein, E.S. et al. (2007) Genome-wide atlas of gene expression in the adult mouse brain, Nature 445: 168-176. [doi: 10.1038/nature05453](10.1038/nature05453).

***

### What's included in the 3D celldetect folder ###
* __OMP_ProbMap.m__: This is the main function used for cell detection, as it implements our greedy sphere finding approach described in [Dyer et al. 2017](https://doi.org/10.1523/ENEURO.0195-17.2017). This algorithm takes a 3D probability map (the same size as the image data) as its input and returns the centroids and confidence value (between 0-1) of all detected cell bodies.
* __compute3dvec.m__: This function places an input 3D template (vec) at a fixed position (which_loc) in a bounding box of width = Lbox*2 + 1.
* __convn_fft.m__: This computes a n-dimensional convolution in the Fourier domain (uses fft rather than spatial convolution to reduce complexity).
* __create_synth_dict.m__: This function creates a collection of spherical templates of different sizes. The output is a dictionary of template vectors, of size (Lbox^3 x length(radii)), where Lbox = box_radius*2 +1 and radii is an input to the function which contains a vector of different sphere sizes.
***

![](https://github.com/nerdslab/celldetect/blob/master/2Dcelldetect/example-output.png?raw=true)

***

_Contributors:_
- Eva Dyer (@evadyer, Georgia Tech)
- Will Gray Roncal (Hopkins APL)
- TJ LaGrow (@tjlagrow, Georgia Tech)

