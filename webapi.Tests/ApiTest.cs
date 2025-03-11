using System.Net;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

// Define a model for deserialization
public record HelloResponse(string message);

public class HelloApiTest : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public HelloApiTest(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task Api_Returns_ValidJsonResponse()
    {
        var response = await _client.GetAsync("/api/hello");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode); // Check HTTP 200 status

        // Deserialize the response into a strongly-typed object
        var jsonResponse = await response.Content.ReadFromJsonAsync<HelloResponse>();
        Assert.NotNull(jsonResponse);
        Assert.Equal("Hello from API! With CI/CD.", jsonResponse.message);
    }
}
