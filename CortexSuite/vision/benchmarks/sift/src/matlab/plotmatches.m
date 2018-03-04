function h=plotmatches(I1,I2,P1,P2,matches,varargin)
% PLOTMATCHES  Plot keypoint matches
%   PLOTMATCHES(I1,I2,P1,P2,MATCHES) plots the two images I1 and I2
%   and lines connecting the frames (keypoints) P1 and P2 as specified
%   by MATCHES.
%
%   P1 and P2 specify two sets of frames, one per column. The first
%   two elements of each column specify the X,Y coordinates of the
%   corresponding frame. Any other element is ignored.
%
%   MATCHES specifies a set of matches, one per column. The two
%   elementes of each column are two indexes in the sets P1 and P2
%   respectively.
%
%   The images I1 and I2 might be either both grayscale or both color
%   and must have DOUBLE storage class. If they are color the range
%   must be normalized in [0,1].
%
%   The function accepts the following option-value pairs:
%
%   'Stacking' ['h']
%      Stacking of images: horizontal [h], vertical [v], diagonal
%      [h], overlap ['o']
%
%   See also PLOTSIFTDESCRIPTOR(), PLOTSIFTFRAME(), PLOTSS().

% AUTORIGHTS
% Copyright (c) 2006 The Regents of the University of California.
% All Rights Reserved.
% 
% Created by Andrea Vedaldi
% UCLA Vision Lab - Department of Computer Science
% 
% Permission to use, copy, modify, and distribute this software and its
% documentation for educational, research and non-profit purposes,
% without fee, and without a written agreement is hereby granted,
% provided that the above copyright notice, this paragraph and the
% following three paragraphs appear in all copies.
% 
% This software program and documentation are copyrighted by The Regents
% of the University of California. The software program and
% documentation are supplied "as is", without any accompanying services
% from The Regents. The Regents does not warrant that the operation of
% the program will be uninterrupted or error-free. The end-user
% understands that the program was developed for research purposes and
% is advised not to rely exclusively on the program for any reason.
% 
% This software embodies a method for which the following patent has
% been issued: "Method and apparatus for identifying scale invariant
% features in an image and use of same for locating an object in an
% image," David G. Lowe, US Patent 6,711,293 (March 23,
% 2004). Provisional application filed March 8, 1999. Asignee: The
% University of British Columbia.
% 
% IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY
% FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES,
% INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND
% ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. THE UNIVERSITY OF
% CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
% A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS"
% BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO PROVIDE
% MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

% --------------------------------------------------------------------
%                                                  Check the arguments
% --------------------------------------------------------------------

stack='h' ;

for k=1:2:length(varargin)
  switch varargin{k}
    case 'Stacking'
      stack=varargin{k+1} ;
  end
end
 
% --------------------------------------------------------------------
%                                                           Do the job
% --------------------------------------------------------------------

[M1,N1,K1]=size(I1) ;
[M2,N2,K2]=size(I2) ;

switch stack
  case 'h'
    N3=N1+N2 ;
    M3=max(M1,M2) ;
    oj=N1 ;
    oi=0 ;
  case 'v'
    M3=M1+M2 ;
    N3=max(N1,N2) ;
    oj=0 ;
    oi=M1 ;    
  case 'd'
    M3=M1+M2 ;
    N3=N1+N2 ;
    oj=N1 ;
    oi=M1 ;
  case 'o'
    M3=max(M1,M2) ;
    N3=max(N1,N2) ;
    oj=0;
    oi=0;
end

I=zeros(M3,N3,K1) ;
I(1:M1,1:N1,:) = I1 ;
I(oi+(1:M2),oj+(1:N2),:) = I2 ;
	 
axes('Position', [0 0 1 1]) ;
imagesc(I) ; colormap gray ; hold on ; axis image ; axis off ;
drawnow ;

K = size(matches, 2) ;
nans = NaN * ones(1,K) ;

x = [ P1(1,matches(1,:)) ; P2(1,matches(2,:))+oj ; nans ] ;
y = [ P1(2,matches(1,:)) ; P2(2,matches(2,:))+oi ; nans ] ;

h = line(x(:)', y(:)') ;
set(h,'Marker','.','Color','g') ;
