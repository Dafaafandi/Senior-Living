<?php
namespace App\Filament\Resources\PatientResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\Patient;

/**
 * @property Patient $resource
 */
class PatientTransformer extends JsonResource
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
