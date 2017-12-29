using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace AspNetCoreInDocker.Web.Controllers
{
    public class ConfigurationController : Controller
    {
        private readonly IConfiguration _config;
        public ConfigurationController(IConfiguration config)
        {
            _config = config;
        }

        public string Index()
        {
            return $"SecretValue: {_config["SecretValue:Key"]}";
        }
    }
}