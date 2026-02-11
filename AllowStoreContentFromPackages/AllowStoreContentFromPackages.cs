
/* SPDX-LICENSE-IDENTIFIER: 0BSD */

using MonoPatcherLib;

using ScriptCore;

using Sims3;
using Sims3.SimIFace;
using Sims3.SimIFace.CustomContent;

namespace AllowStoreContentFromPackages
{
	[MonoPatcherLib.Plugin]
	public sealed class ModEntryPoint
	{
		public ModEntryPoint ()
		{
			ApplyPatches();
		}

		public static void ApplyPatches ()
		{
			MonoPatcher.ReplaceMethod(
				typeof(ScriptCore.DownloadContent).GetMethod("GetContentCategory", new[]{typeof(ResourceKey)}),
				typeof(DownloadContentPatches).GetMethod("GetContentCategory")
			);
		}
	}

	public sealed class DownloadContentPatches
	{
		public ResourceKeyContentCategory GetContentCategory (ResourceKey key)
		{
			switch (ScriptCore.DownloadContent.DownloadContent_GetContentSourceImpl(key))
			{
			case (uint) ContentSourceType.kContentType_Installed:
				return ResourceKeyContentCategory.kInstalled;
			case (uint) ContentSourceType.kContentType_Download:
				uint groupId = key.GroupId;

				groupId &= (uint) (ContentCategoryFlags.kPaidContent | ContentCategoryFlags.kCustomContent);

				if ((groupId & (uint) ContentCategoryFlags.kPaidContent) != 0)
				{
					return ResourceKeyContentCategory.kPaidDownloadedEA;
				}

				if ((groupId & (uint) ContentCategoryFlags.kCustomContent) != 0)
				{
					return ResourceKeyContentCategory.kUserCreated;
				}

				return ResourceKeyContentCategory.kFreeDownloadedEA;
			case (uint) ContentSourceType.kContentType_Local:
				return (
					     (key.GroupId & (uint) (ContentCategoryFlags.kPaidContent | ContentCategoryFlags.kCustomContent))
					  != (uint) ContentCategoryFlags.kPaidContent
					? ResourceKeyContentCategory.kLocalUserCreated
					: ResourceKeyContentCategory.kPaidDownloadedEA
				);
			default:
				if (key.TypeId == (uint) ResourceTypes.kHairColorInfoResourceID)
				{
					return ResourceKeyContentCategory.kLocalUserCreated;
				}

				return ResourceKeyContentCategory.kInstalled;
			}
		}
	}
}

