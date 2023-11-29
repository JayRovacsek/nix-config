_: {
  name = "DlnaOptions";
  props = ''
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

  value = [
    {
      name = "EnablePlayTo";
      value = false;
    }
    {
      name = "EnableServer";
      value = false;
    }
    {
      name = "EnableDebugLog";
      value = false;
    }
    {
      name = "BlastAliveMessages";
      value = false;
    }
    {
      name = "SendOnlyMatchedHost";
      value = true;
    }
    {
      name = "ClientDiscoveryIntervalSeconds";
      value = 60;
    }
    {
      name = "BlastAliveMessageIntervalSeconds";
      value = 1800;
    }
  ];
}
