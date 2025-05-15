<?php
namespace App\Filament\Resources\ReminderResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\Reminder;

/**
 * @property Reminder $resource
 */
class ReminderTransformer extends JsonResource
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
