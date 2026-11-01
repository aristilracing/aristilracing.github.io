-- Configuration du stockage des photos de profil ARISTIL Racing
-- À exécuter une seule fois dans Supabase > SQL Editor > New query.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'profile-photos',
  'profile-photos',
  true,
  3145728,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = true,
  file_size_limit = 3145728,
  allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp'];

drop policy if exists "Pilotes peuvent envoyer leur photo" on storage.objects;
create policy "Pilotes peuvent envoyer leur photo"
on storage.objects for insert to authenticated
with check (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Photos de profil visibles" on storage.objects;
create policy "Photos de profil visibles"
on storage.objects for select to public
using (bucket_id = 'profile-photos');

drop policy if exists "Pilotes peuvent modifier leur photo" on storage.objects;
create policy "Pilotes peuvent modifier leur photo"
on storage.objects for update to authenticated
using (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Pilotes peuvent supprimer leur photo" on storage.objects;
create policy "Pilotes peuvent supprimer leur photo"
on storage.objects for delete to authenticated
using (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text);
