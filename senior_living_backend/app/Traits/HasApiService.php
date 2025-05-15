<?php

namespace App\Traits;

trait HasApiService
{
    public static function getApiResource(): string
    {
        return static::class;
    }
}