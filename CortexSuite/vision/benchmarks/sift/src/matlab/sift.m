% Input:
%   I          the input image, with pixel values normalize to lie betwen [0,1].
%
% Output:
%   features    a structure which contains the following fields:
%       pos     an n*2 matrix containing the (x,y) coordinates of the keypoints
%               stored in rows.
%       scale   an n*3 matrix with rows describing the scale of each keypoint
%               (i.e., first column specifies the octave, second column specifies the interval, and
%               third column specifies sigma).
%       orient  a n*1 vector containing the orientations of the keypoints [-pi,pi).
%       desc    an n*128 matrix with rows containing the feature descriptors 
%               corresponding to the keypoints.

function [frames]=sift(I)

[M,N,C] = size(I) ;

% Lowe's choices
S=3 ;
omin=-1 ;
O=floor(log2(min(M,N)))-omin-4 ; % Up to 16x16 images
sigma0=1.6*2^(1/S) ;
sigman=0.5 ;
thresh = 0.04 / S / 2 ;
r = 10 ;

NBP = 4 ;
NBO = 8 ;
magnif = 3.0 ;

% Parese input
compute_descriptor = 0 ;
discard_boundary_points = 1 ;
verb = 0 ;

smin = -1;
smax = S+1;
intervals = smax - smin + 1;


% --------------------------------------------------------------------
%                                                           Parameters
% --------------------------------------------------------------------

oframes = [] ;
frames = [] ;
descriptors = [] ;

% --------------------------------------------------------------------
%                                         SIFT Detector and Descriptor
% --------------------------------------------------------------------

% Compute scale spaces
%if verb > 0, fprintf('SIFT: computing scale space...') ; end

gss = gaussianss(I,sigman,O,S,omin,-1,S+1,sigma0) ;
dogss = diffss(gss) ;
frames = [];

%% To maintain consistency with C code. Once C code is ready, this will be uncommented.
for o=1:O                               %for o=1:O 
	
	% Local maxima of the DOG octave
	% The 80% tricks discards early very weak points before refinement.
	 
    idx = siftlocalmax(  dogss.octave{o}, 0.8*thresh  ) ;
 	idx = [idx , siftlocalmax( - dogss.octave{o}, 0.8*thresh)] ;  
   
 	K=length(idx) ; 
 	[i,j,s] = ind2sub( size( dogss.octave{o} ), idx ) ;
    
    y=i-1 ;
 	x=j-1 ;
 	s=s-1+dogss.smin ;
    oframes = [x(:)';y(:)';s(:)'] ;

%    fWriteMatrix(oframes, '../data/sim');
 	
 	% Remove points too close to the boundary
 	if discard_boundary_points
 		oframes = filter_boundary_points(size(dogss.octave{o}), oframes ) ;
 	end
 		
 	% Refine the location, threshold strength and remove points on edges
 	oframes = siftrefinemx(...
 		oframes, ...
 		dogss.octave{o}, ...
 		dogss.smin, ...
 		thresh, ...
 		r) ;
    
   frames = [frames, oframes];     
 
end
end

%% --------------------------------------------------------------------
%%                                                              Helpers
%% --------------------------------------------------------------------
function oframes=filter_boundary_points(sz, oframes)

sel=find(...
	oframes(1,:) > 3 & ...
	oframes(1,:) < sz(2)-3 & ...
	oframes(2,:) > 3 & ...
	oframes(2,:) < sz(1)-3 ) ;

oframes=oframes(:,sel) ;
end
