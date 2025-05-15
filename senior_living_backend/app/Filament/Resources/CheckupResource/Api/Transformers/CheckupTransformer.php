<?php
namespace App\Filament\Resources\CheckupResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\Checkup;

/**
 * @property Checkup $resource
 */
class CheckupTransformer extends JsonResource
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
