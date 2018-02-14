# Cell detection via sparse approximation

This repository contains Matlab code for _detecting cells in 3D image volumes and 2D images_. 

You can find further details about how we apply the methods in this repo to analyze mm-scale brain volumes in the following paper:

__Dyer, Eva L., et al. "Quantifying mesoscale neuroanatomy using X-ray microtomography", eNeuro 25 September 2017, 4 (5) ENEURO.0195-17.2017 [[Link to Paper]](https://doi.org/10.1523/ENEURO.0195-17.2017).__

If you use any of the code or datasets in this repo, please cite this paper. 
Please direct any questions to Eva Dyer at evadyer{at}gatech{dot}edu.
***

### Computing a probability map for your images ###

The input to our cell detection algorithm is a "probability map" that encodes the probability that each voxel/pixel corresponds to a cell body.

One easy way to compute a probability map for your image data is to use [Ilastik](http://ilastik.org) to compute the pixel probabilities. The ilastik team provides great documentation on their website for creating a [Pixel Classifier](http://ilastik.org/documentation/pixelclassification/pixelclassification). You can also see an example of a Pixel Classifier in our 2D demo data (see below for a link to download our data and classifiers).

In some images where the intensity of a pixel is a good indicator of the foreground and backgroun, you can simply use the image, but you need to rescale it first so the background pixels have values close to zero and cell pixels have values close to one.
***
### Download Data ###
If you want to run any of the demos in this repository, please download the data from [DropBox](https://www.dropbox.com/s/0tvqulvno0awyzj/celldetect-demo-data.zip?dl=0) first.
***
### Example 1 - run 3D cell finding algorithm
To begin, run the script ___script_cellfinder.m___. This script will run the main cell finding routine ___OMP_ProbMap.m___ on the test data in the celldetect folder. The output includes two variables: (1) _Centroids_, a 10x4 matrix with the position (x,y,z) first 10 detected cells centroids (columns 1-3) and the correlation value between all detected cells and theinput probability map (column 4). (2) _Nmap_, a 200x200x100 matrix with all of the detected cells labeled with a unique ID (and the remaining volume labeled w/ zeros).

To find more cells in the volume, set kmax to a larger number. The variable _kmax_ controls the maximum number of iterations of the algorithms (and constrains the maximum number of detected cells). 

To find the top 100 cells, call the greedy sphere finder method again (this will take a few minutes).
```matlab
kmax = 100; 
[Centroids,Nmap] = OMP_ProbMap(Prob,ptr,presid,startsz,dilatesz,kmax);
```

#### Visualize ####
__(1) Visualize the detected cells overlaid on probabilities__
  ```matlab
figure; 
for i=1:size(Prob,3) 
    imagesc(Prob(:,:,i)-(Nmap(:,:,i)~=0)), 
    pause, 
end
  ```
***  
  ### Example 2 - run 2D cell finding algorithm on a Nissl image ###
To test our methods on 2D image data, run the script ___script_run2Dcelldetect___. This will output the centroids and map of the detected cell bodies (each cell is labeled with a unique ID).

If you use the test data (from the Allen Institute Reference Atlas) provided in this example, please cite the following paper:

Lein, E.S. et al. (2007) Genome-wide atlas of gene expression in the adult mouse brain, Nature 445: 168-176. [doi: 10.1038/nature05453](10.1038/nature05453).

***

### What's included in the 3D celldetect folder ###
* __OMP_ProbMap.m__: This is the main function used for cell detection, as it implements our greedy sphere finding approach described in [Dyer et al. 2016](https://arxiv.org/abs/1604.03629). This algorithm takes a 3D probability map (the same size as the image data) as its input and returns the centroids and confidence value (between 0-1) of all detected cell bodies.
* __compute3dvec.m__: This function places an input 3D template (vec) at a fixed position (which_loc) in a bounding box of width = Lbox*2 + 1.
* __convn_fft.m__: This computes a n-dimensional convolution in the Fourier domain (uses fft rather than spatial convolution to reduce complexity).
* __create_synth_dict.m__: This function creates a collection of spherical templates of different sizes. The output is a dictionary of template vectors, of size (Lbox^3 x length(radii)), where Lbox = box_radius*2 +1 and radii is an input to the function which contains a vector of different sphere sizes.
***

![](https://github.com/nerdslab/celldetect/blob/master/2Dcelldetect/example-output.png?raw=true)
