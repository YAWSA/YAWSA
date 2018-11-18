<?php
use app\assets\AppAsset;
use app\models\User;
use yii\bootstrap\Nav;
use yii\bootstrap\NavBar;
use yii\helpers\Html;
use yii\helpers\Url;
use app\components\FlashMessage;

/* @var $this \yii\web\View */
/* @var $content string */

$this->title = yii::$app->name;
AppAsset::register($this);
?>
<?php $this->beginPage()?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width,initial-scale=1,maximum-scale=1">
<meta charset="<?= Yii::$app->charset ?>" />
    <?= Html::csrfMetaTags()?>
    <title><?= Html::encode($this->title) ?></title>
    <?php $this->head()?>


<link rel="shortcut icon"
	href="<?= $this->theme->getUrl('img/fav_icon.png')?>" type="image/png">


<link rel="canonical" href="<?php echo Url::canonical();?>">
<!--common style-->
<link
	href="<?php echo $this->theme->getUrl('css/style-'. $this->theme->style . '.css')?>"
	rel="stylesheet">

<link
	href="<?php echo $this->theme->getUrl('css/style-responsive.css')?>"
	rel="stylesheet">
<!--theme color layout-->
<link
	href="<?php echo $this->theme->getUrl('css/layout-theme-two.css')?>"
	rel="stylesheet">

</head>
<body class="sticky-header">
<?php $this->beginBody()?>

	<section>
		<header role="banner" id="top"
			class="navbar navbar-static-top bs-docs-nav bg-danger light-color ">
			<div class="container">
				<div class="navbar-header">
					<button aria-expanded="false" aria-controls="bs-navbar"
						data-target="#bs-navbar" data-toggle="collapse" type="button"
						class="navbar-toggle collapsed">
						<span class="sr-only">Toggle navigation</span> <span
							class="icon-bar"></span> <span class="icon-bar"></span> <span
							class="icon-bar"></span>
					</button>

					<a class="navbar-brand" href="<?php echo Url::home();?>"> &nbsp; <span
						class="brand-name"><?= Yii::$app->name?> </span>
					</a>

				</div>
				<nav class="collapse navbar-collapse" id="bs-navbar">
					<ul class=" nav navbar-nav navbar-right mega-menu">
						<!-- <li><a href="<?php //echo Url::to(['site/contact']);?>">Contact</a>
						</li>
						<li>-->

						<?php   if(User::isGuest()){?>
						<li><a href="<?php echo Url::to(['user/login']);?>">Login</a></li>

						<?php
    } else {
        ?>
							<li><a href="<?php echo Url::to(['user/dashboard']);?>">Dashboard</a></li>


					<?php 	}?>
					</ul>


				</nav>
			</div>
		</header>

		<!-- body content start-->

		<div class="main_wrapper well site-index bg relative no-pad">
			<div class="img-overlay"></div>
			<div class="header no-pad">
				<!-- header section start-->

				<!--body wrapper start-->
				 <?= FlashMessage::widget (['type' => 'notify', /*'position' => 'bottom-right'*/  ]) ?>
                 <?= $content?>
          </div>
		</div>
		<!--body wrapper end-->
		<footer id="footer">
			<div class="">
				<div class="text-center footer-bottom">
					<p class="m-t-10">&copy; <?php echo date('Y')?>  <?= Yii::$app->name;?>  | All Rights
			Reserved	| Powered by <a 
							href="#"><?= Yii::$app->params['company']?></a>
					</p>
					<p class="hosting m-t-10">
						Hosting Partner <a href="https://jiwebhosting.com/"
							target="_blank">jiWebHosting.com</a>
					</p>
				</div>
			</div>
		</footer>


		<!-- body content end-->

	</section>
	<!--Nice Scroll-->
	<script
		src="<?php echo $this->theme->getUrl('js/jquery.nicescroll.js')?>"
		type="text/javascript"></script>

	<!--right slidebar-->
	<script src="<?php echo $this->theme->getUrl('js/slidebars.min.js')?>"></script>

	<!--common scripts for all pages-->
	<script src="<?php echo $this->theme->getUrl('js/scripts.js')?>"></script>
<?php $this->endBody()?>



	<script>
	$(document).ready(function() {
		  function setHeight() {
		    windowHeight = $(window).innerHeight() -100;
		    $('.main_wrapper').css('min-height', windowHeight);
		  };
		  setHeight();
		  $(window).resize(function() {
		    setHeight();
		  });
	});
</script>
</body>


<?php $this->endPage()?>

</html>
