<?php
namespace App\Filament\Resources\HospitalVisitResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\HospitalVisit;

/**
 * @property HospitalVisit $resource
 */
class HospitalVisitTransformer extends JsonResource
{

    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return $this->resource->toArray();
    }
}
