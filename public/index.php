<?php
	include( __DIR__ . '/partials/content.php');

	global $meta;
	$meta = $home['meta'];

	include( __DIR__ . '/partials/header.php');
?>

<!-- YOUR CODE HERE -->
<p style="font-size:100px; font-weight: 800; color: white; text-shadow: 0 1px 0 #ccc, 0 2px 0 #c9c9c9, 0 3px 0 #bbb, 0 4px 0 #b9b9b9, 0 5px 0 #aaa, 0 6px 1px rgba(0,0,0,.1), 0 0 5px rgba(0,0,0,.1), 0 1px 3px rgba(0,0,0,.3), 0 3px 5px rgba(0,0,0,.2), 0 5px 10px rgba(0,0,0,.25), 0 10px 10px rgba(0,0,0,.2), 0 20px 20px rgba(0,0,0,.15);">
  <?= $home['title'] ?>
</p>



<div class="posts">
  <h3><?= $news['title'] ?></h3>

  <? foreach($news['posts'] as $post) { ?>

    <div class="post">
      <p><strong><?= $post['title'] ?></strong> - <?= $post['date'] ?></p>
      <?= $post['content'] ?>
    </div>

  <? } ?>
</div>


<?php include (__dir__ . '/partials/footer.php'); ?>
