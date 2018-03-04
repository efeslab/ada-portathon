Tools for computing distributed representtion of words
------------------------------------------------------

We provide an implementation of the Continuous Bag-of-Words (CBOW) and the Skip-gram model (SG), as well as several demo scripts.

Given a text corpus, the word2vec tool learns a vector for every word in the vocabulary using the Continuous
Bag-of-Words or the Skip-Gram neural network architectures. The user should to specify the following:
 - desired vector dimensionality
 - the size of the context window for either the Skip-Gram or the Continuous Bag-of-Words model
 - training algorithm: hierarchical softmax and / or negative sampling
 - threshold for downsampling the frequent words 
 - number of threads to use
 - the format of the output word vector file (text or binary)

Usually, the other hyper-parameters such as the learning rate do not need to be tuned for different training sets. 

-------------------------------------------------------
Word2Vec is an algebraic model for generating efficient represention of documents as a collection of word vectors. These vectors can be generated with the help of 
a learning algorithm operating on a vocabulary derived from large corpus. The learning model uses Stochastic Gradient Descent with Backpropagation. Estimation of 
word vectors has been performed using two algorithms from neural networks: Continuous Bag of Words (CBOW) and Skip-Gram (SG). Both models analyzes each word and 
its context, which is nothing but a window of words (forward and backward) around the target word. By tuning the number of elements in the window, varying degrees 
of prediction accuracy are obtained. While continuous bag of words is used for predicting the word given its context, the skip gram algorithm is used for predicting 
the context given a word. Skip-gram is named so because the context is not limited to the immediate context, but it can also be created by skipping a 'constant' 
number of words in its context. By tuning the number of elements in the window, varying degrees of prediction accuracy are obtained. These word vectors are crucial 
as they provide efficient semantic as well as syntactic predictions. This vector space model can then be used for information filtering, information retrieval, 
indexing and various relevancy rankings.
