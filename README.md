A simple neural network based off the excellent book [Make Your Own Neural Network](https://www.amazon.com/Make-Your-Own-Neural-Network/dp/1530826608) by Tariq Rashid, implemented in Elixir rather than Python simply because I thought it would be more interesting.

## Running the network

1. clone the repo.
2. `mix deps.get` to install dependencies.
3. compile the project with `mix compile`. This project depends on [Matrex](https://github.com/versilov/matrex?tab=readme-ov-file#installation), a matrix library for Elixir which relies on C native code. If you have trouble compiling Matrex, please refer to the [Matrex installation instructions](https://github.com/versilov/matrex?tab=readme-ov-file#installation).
4. `mix train` to train the network and save the resulting weights. A minimal set of training data is included in `datasets/mnist_train_100.csv`, the full dataset can be downloaded [here](https://pjreddie.com/projects/mnist-in-csv/).
5. `mix evaluate` to test the network against the MNIST handwritten digits dataset.
