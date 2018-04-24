using System;
using Xunit;

namespace AspNetCoreInDocker.Lib.Tests
{
    public class UnitTest1
    {
        [Fact]
        public void Test1()
        {
            throw new Exception("Testing that this fails the build");
        }
    }
}
