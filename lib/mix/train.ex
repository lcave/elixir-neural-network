defmodule Mix.Tasks.Train do
  use Mix.Task

  def run(_args) do
    NeuralNetwork.train()
  end
end
