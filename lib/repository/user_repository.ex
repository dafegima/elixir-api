defmodule RestApi.Repository.UserRepository do
  def query_mongo_db(identification) do

    mongo_query = fn ->
      IO.puts("querying mongo")
      Mongo.find_one(:mongo, "users", %{"identification"=> identification})
    end

    t = GenRetry.Task.async(mongo_query, retries: 3)
    result = Task.await(t)

    if (result != nil) do
      Enum.to_list(result)
      |> Enum.into(%{})
      |> Map.delete("_id")
    end

  end

  def add_user(user) do
    {result, %Mongo.InsertOneResult{
      acknowledged: acknowledged
    }} = Mongo.insert_one(:mongo, "users", user)
     { result, acknowledged }
  end

  def delete_user(identification) do
    Mongo.delete_one(:mongo, "users", %{"identification"=> identification})
  end
end
