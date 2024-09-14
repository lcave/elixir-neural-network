defmodule Mix.Tasks.Evaluate do
  use Mix.Task

  def run(_args) do
    NeuralNetwork.evaluate()
  end
end
