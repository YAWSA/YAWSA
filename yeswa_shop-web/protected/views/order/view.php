<?php
use app\components\useraction\UserAction;
use app\modules\comment\widgets\CommentsWidget;

/* @var $this yii\web\View */
/* @var $model app\models\Order */

/* $this->title = $model->label() .' : ' . $model->id; */
$this->params ['breadcrumbs'] [] = [ 
		'label' => Yii::t ( 'app', 'Orders' ),
		'url' => [ 
				'index' 
		] 
];
$this->params ['breadcrumbs'] [] = ( string ) $model;
?>
<div class="page-wrapper">
	<div class="wrapper">
		<div class="panel">
			<div class="order-view panel-body">
			<?php echo  \app\components\PageHeader::widget(['model'=>$model]); ?>
		</div>
		</div>

		<div class=" panel ">
			<div class=" panel-body ">
    <?php
				
				echo \app\components\TDetailView::widget ( [ 
						'id' => 'order-detail-view',
						'model' => $model,
						'options' => [ 
								'class' => 'table table-bordered' 
						],
						'attributes' => [ 
								'id',
								[ 
										'attribute' => 'super_order_id',
										'label' => 'Order Number',
										'format' => 'raw',
										'value' => isset ( $model->superOrder ) ? $model->superOrder->order_number : "" 
								],
								
								[ 
										'attribute' => 'vendor_id',
										'format' => 'raw',
										'value' => isset ( $model->vendor ) ? $model->vendor->full_name : "" 
								],
								
								'shipping_charge',
								[ 
										'attribute' => 'shipping_address',
										'format' => 'raw',
										'value' => isset ( $model->superOrder->shippingAddress ) ? $model->superOrder->shippingAddress : "(Not Set)" 
								],
								
								[ 
										'attribute' => 'latitude',
										'format' => 'raw',
										'value' => isset ( $model->superOrder->shippingAddress ) ? $model->superOrder->shippingAddress->lat : "(Not Set)" 
								],
								[ 
										'attribute' => 'longitude',
										'format' => 'raw',
										'value' => isset ( $model->superOrder->shippingAddress ) ? $model->superOrder->shippingAddress->long : "(Not Set)" 
								],
								[ 
										'attribute' => 'state_id',
										'format' => 'raw',
										'value' => $model->getStateBadge () 
								],
								[ 
										'attribute' => 'state_id',
										'format' => 'raw',
										'value' => $model->getStateBadge () 
								],
								
            /*[
			'attribute' => 'type_id',
			'value' => $model->getType(),
			],*/
            'created_on:datetime',
								'updated_on:datetime',
								[ 
										'attribute' => 'created_by_id',
										'format' => 'raw',
										'value' => $model->getRelatedDataLink ( 'created_by_id' ) 
								] 
						] 
				] )?>


<?php  ?>


		<?php
		
		echo UserAction::widget ( [ 
				'model' => $model,
				'attribute' => 'state_id',
				'states' => $model->getStateOptions () 
		] );
		?>

		</div>
		</div>



		<div class="panel">
			<div class="panel-body">
				<div class="order-panel">

<?php
$this->context->startPanel ();
$this->context->addPanel ( 'OrderItems', 'orderItems', 'OrderItem', $model );

$this->context->endPanel ();
?>
				</div>
			</div>
		</div>

		<div class=" panel ">
			<div class=" panel-body ">

				<div id="driver_googleMap1" style="width: 100%; height: 400px"></div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"
	src="http://maps.googleapis.com/maps/api/js?libraries=geometry,places&sensor=false&key=AIzaSyCpn6UI8kqIXLQE1e8aUrXFlayJb8P-QdE"></script>
<script type="text/javascript">


var citymap = {
	     location: {
	          center: {lat: <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->lat:""?>, lng: <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->long:""?>},
	          population: 3
	        },
	      
	      };




	function initMap() {
	    // Create the map.
	    var map = new google.maps.Map(document.getElementById('driver_googleMap1'), {
	      zoom: 15,
	      center: {lat:  <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->lat:""?>, lng: <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->long:""?>},
	    });
	    marker = new google.maps.Marker({
	        map: map,
	        draggable: true,
	        animation: google.maps.Animation.DROP,
	        position: {lat:  <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->lat:""?>, lng: <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->long:""?>}
	      });
	    var infowindow = new google.maps.InfoWindow();

		google.maps.event.addListener(marker, 'click', (function(marker) {
			var html='';
		 html += "<strong><?php echo isset($model->superOrder->shippingAddress->address)? $model->superOrder->shippingAddress->address:"" ?></strong>";
	       return function() {
	             infowindow.setContent( html );
	             infowindow.open(map, marker);
	       }
	   })(marker));
	      marker.addListener('click', toggleBounce);
	    // Construct the circle for each value in citymap.
	    // Note: We scale the area of the circle based on the population.
	    for (var city in citymap) {
	      // Add the circle for this city to the map.
	      var cityCircle = new google.maps.Circle({
	        strokeColor: '#FF0000',
	        strokeOpacity: 0.8,
	        strokeWeight: 2,
	        fillColor: '#FF0000',
	        fillOpacity: 0.35,
	        map: map,
	        center: {lat:  <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->lat:""?>, lng: <?php echo isset($model->superOrder->shippingAddress->lat)?$model->superOrder->shippingAddress->long:""?>},
	        radius: 3 * 100
	      });
	    }
	  }



	


	function toggleBounce() {
	    if (marker.getAnimation() !== null) {
	      marker.setAnimation(null);
	    } else {
	      marker.setAnimation(google.maps.Animation.BOUNCE);
	    }
	  }


	$(document).ready(function(){
		initMap();


		
	});








</script>