<?php 

namespace App;

/**
* App
*/
class App
{
    const CONFIGURATION_DIR = './Config/';
    
    private $configuration = [];

    public function __construct()
    {
        $this->getConfiguration();
    }
    
    public function run()
    {
        require_once 'Core/Psr4Autoloader.php';
        #use App\Connection\Database;

        $loader = new \App\Core\Psr4Autoloader;
        $loader->register();
        $loader->addNamespace('App', '.');

        $con = new \App\Core\Database($this->configuration['database']);
        #$con->connect();
    }

    private function getConfiguration()
    {
        $configs = glob(self::CONFIGURATION_DIR . "*.yaml");
        
        //print each file name
        foreach($configs as $path)
        {
            // get file name
            $pathItems = explode('/', $path);
            //remove extension
            $configurationType = explode('.', $pathItems[2])[0];

            $parsedConfigs = yaml_parse_file($path);

            $this->configuration[$configurationType] = $parsedConfigs;
        }
    }
}


$app = new App;

$app->run();