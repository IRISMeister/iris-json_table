Class MyApps.Installer
{

ClassMethod setup(ByRef tVars) As %Status
{
  Set tSC='$$$OK
  Try {
    New $NAMESPACE
    Set $NAMESPACE="%SYS"
    Do ##class(Security.SSLConfigs).Create("Default")

    Set $NAMESPACE="USER"
    Do $System.OBJ.ImportDir("/home/irisowner/src/MyApp","*.xml;*.cls;*.mac;*.int;*.inc;*.dfi","ck",,1)

    Set tSC=$$$OK
  } Catch(e) {
	  Set tSC=e.AsStatus()
  }
  Return tSC
}

}
