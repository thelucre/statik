<?php
// Load Webpack manifest to load the HMR or compiled js
$manifest = json_decode(file_get_contents( __DIR__ . '/../dist/manifest.json'));
?>

<!doctype html>
<html class="no-js" lang="">
  <head>
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">

		<?php include (__dir__ . '/../partials/meta.php'); ?>

    <link rel="stylesheet" href="<?= $manifest->app->css ?>">
  </head>
  <body>

  <?php include (__dir__ . '/../partials/nav.php'); ?>
