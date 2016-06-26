<?php
/*****************************************
 * GLOBAL SITE CONTENT
 *
 * Data is stored in .yaml files and parsed at runtime.
 *****************************************/

// Load compoaser dependencies
include( __dir__ . '/../vendor/autoload.php');

/**
 * Globally load site content for access across views.
 * See '/content.yaml' for the values
 */

use Symfony\Component\Yaml\Parser;
use League\Csv\Reader;

// Using the yaml parser to read content files
global $yaml;
$yaml = new Parser();


/**
 *
 */
function getContent($parser, $path) {
		return $parser->parse(file_get_contents( __dir__ . '/../content/' .$path));
}

$global = getContent($yaml, 'global.yaml');

// Content for main landing pages
$home = getContent($yaml, 'home.yaml');
$news = getContent($yaml, 'news.yaml');
